platform :ios, '14.0'

target 'instyfy' do
  use_frameworks!

  # Firebase pods
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'GoogleSignIn'



  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386'
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
      end
    end
  end
end
