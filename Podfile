# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

# source 'https://github.com/alexdelarge05/DatingKit.git'

target 'FAWN' do
  use_frameworks!

  pod 'AlamofireImage', '~> 3.5'
  pod 'RevealingTableViewCell'
  pod 'lottie-ios'
  pod 'SwiftyStoreKit'
  pod 'TKImageShowing'
  pod 'Amplitude-iOS', '~> 4.0.4'
  pod 'NotificationBannerSwift'

  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'

  pod 'Fabric', '~> 1.10.2'
  pod 'Crashlytics', '~> 3.14.0'

  pod 'DatingKit', :git => 'https://bitbucket.org/sergeyzhilkin/dating-kit.git', :branch => 'develop'
  pod 'ReverseExtension', :git => 'https://github.com/alexdelarge05/ReverseExtension.git', :commit =>  'f46463468b608c9189846c374863cdeb03f15bb4'

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    # Workaround for CocoaPods issue: https://github.com/CocoaPods/CocoaPods/issues/7606
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
    
    # Do not need debug information for pods
    config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    
    # Disable Code Coverage for Pods projects - only exclude ObjC pods
    config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
    config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = ['$(FRAMEWORK_SEARCH_PATHS)']
    
    config.build_settings['SWIFT_VERSION'] = '4.2'
  end
end
