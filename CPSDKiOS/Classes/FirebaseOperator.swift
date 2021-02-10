//
//  FirebaseOperator.swift
//  FBSDKConsumer_Example
//
//  Created by Max Tripilets on 27.06.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseInstanceID
import FirebaseMessaging

public class FirebaseOperator {
    var gregorConnector: cpConnectionService!
    
    public init(gregorysConnector: cpConnectionService) {
        gregorConnector = gregorysConnector
    }
    
    public func askforregistration(_ application: UIApplication) {
        self.gregorConnector.printMsg(message:"fbapp:\(String(describing: FirebaseApp.app())), isfirinc: \(cpMainParameters.shared.isFIRAlreadyInc)")
        if(FirebaseApp.app() == nil && cpMainParameters.shared.isFIRAlreadyInc != "yes"){
            FirebaseApp.configure()
        }

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let center = UNUserNotificationCenter.current()
            center.delegate = self as? UNUserNotificationCenterDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            center.requestAuthorization(options: authOptions) {
                (granted, error) in
                if !granted {
                    cpMainParameters.shared.notsAllowed = "no"
                    UserDefaults.standard.set(cpMainParameters.shared.notsAllowed,forKey: "notsAllowed")
                    UserDefaults.standard.synchronize()
                    self.gregorConnector.postDeniedFCMToCP()
                } else {
                    cpMainParameters.shared.notsAllowed = "yes"
                    UserDefaults.standard.set(cpMainParameters.shared.notsAllowed,forKey: "notsAllowed")
                    UserDefaults.standard.synchronize()
                    _ = self.getRegistrationToken()
                }
                self.gregorConnector.printMsg(message: "askforregistration notsAllowed:\(cpMainParameters.shared.notsAllowed)")

            }
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus != .authorized {
                    cpMainParameters.shared.notsAllowed = "no"
                    UserDefaults.standard.set(cpMainParameters.shared.notsAllowed,forKey: "notsAllowed")
                    UserDefaults.standard.synchronize()
                    //self.postDeniedFCMToCP()
                } else {
                    cpMainParameters.shared.notsAllowed = "yes"
                    UserDefaults.standard.set("yes",forKey: "notsAllowed")
                    UserDefaults.standard.synchronize()
                }
                self.gregorConnector.printMsg(message: "askforregistration notsAllowed:\(cpMainParameters.shared.notsAllowed)")
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self as? MessagingDelegate
//        Messaging.messaging().shouldEstablishDirectChannel = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getRefreshedRegistrationToken(notification:)), name: NSNotification.Name.MessagingRegistrationTokenRefreshed, object: nil)
        _ = NotificationCenter.default.addObserver(forName: NSNotification.Name.MessagingRegistrationTokenRefreshed, object: nil, queue: nil) {_ in
            Messaging.messaging().token {(result,error) in
                if let error = error {
                    self.gregorConnector.printMsg(message: "askforregistration error:Error!!!!! fetching remote instance Id: \(error)")
                } else if let result = result {
                    let fcmToken = result
                    self.gregorConnector.printMsg(message: "askforregistration fcmToken:\(fcmToken)")

                    self.gregorConnector.postFCMTokenToCP(fcmToken:fcmToken)
                } else {
                    self.gregorConnector.printMsg(message: "askforregistration error:Error!!!!! Unknown getting fcmToken")
                }
            }
        }
    }
    public func getRegistrationToken() -> String{
        var fcmToken = "";
        Messaging.messaging().token {(result,error) in
            if let error = error {
                self.gregorConnector.printMsg(message: "getRegistrationToken error:Error!!!!! fetching remote instance Id: \(error)")
            } else if let result = result {
                fcmToken = result
                self.gregorConnector.printMsg(message: "getRegistrationToken fcmToken:\(fcmToken)")
                self.gregorConnector.postFCMTokenToCP(fcmToken: fcmToken)
                cpMainParameters.shared.isPushActive = true
            } else {
                self.gregorConnector.printMsg(message: "getRegistrationToken error:Error!!!!! Unknown getting fcmToken")
            }
        }
        return fcmToken
    }
    @objc func getRefreshedRegistrationToken(notification: NSNotification){
        Messaging.messaging().token {(result,error) in
            if let error = error {
                self.gregorConnector.printMsg(message: "getRefreshedRegistrationToken error:Error!!!!! fetching remote instance Id: \(error)")
            } else if let result = result {
                let fcmToken = result
                
                self.gregorConnector.printMsg(message: "getRefreshedRegistrationToken fcmToken:\(fcmToken)")

                self.gregorConnector.postFCMTokenToCP(fcmToken:fcmToken)
            } else {
                self.gregorConnector.printMsg(message: "getRefreshedRegistrationToken error:Error!!!!! Unknown getting fcmToken")
            }
        }
    }
}
