platform :ios, '13.0'

target 'instyfy' do
  use_frameworks!

  # Firebase pods
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        # Exclude simulator architectures that may cause code-sign issues
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386'
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
      end
    end
  end
end
