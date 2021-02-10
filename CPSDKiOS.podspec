#
# Be sure to run `pod lib lint CPSDKiOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CPSDKiOS'
  s.version          = '0.0.4'
  s.summary          = 'A CocoaPods library written in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://www.contactpigeon.com/cp/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mtripilec' => 'dasd' }
  s.source           = { :git => 'https://cptestdev@github.com/cptestdev/cpsdkios.git', :tag => 'v0.0.4' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'CPSDKiOS/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CPSDKiOS' => ['CPSDKiOS/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation', 'FirebaseCore', 'FirebaseInstanceID', 'FirebaseMessaging'
  s.dependency 'Firebase/Core', '~> 7.5'
  s.dependency 'Firebase/Messaging', '~> 7.5'
  s.static_framework = true
end