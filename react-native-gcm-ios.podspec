Pod::Spec.new do |s|
  s.name             = "react-native-gcm-ios"
  s.version          = "0.1.0"
  s.summary          = "iOS GCM support for React Native apps."
  s.requires_arc = true
  s.author       = { 'cmcewen' => 'connor.mcewen@gmail.com' }
  s.license      = 'MIT'
  s.homepage     = 'n/a'
  s.source       = { :git => "https://github.com/cmcewen/react-native-push-notification.git" }
  s.source_files = 'RNGcmIOS/*.{h,m}'
  s.platform     = :ios, "7.0"
  s.dependency 'React'
  s.dependency 'Google/CloudMessaging'
end
