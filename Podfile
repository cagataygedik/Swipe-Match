# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Swipe&Match' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Swipe&Match

  pod 'Firebase/Firestore’
  pod 'Firebase/Auth’
  pod 'Firebase/Storage’
  pod 'Firebase/Core’
  pod 'SDWebImage','~>5.15.5’
  pod 'JGProgressHUD','~>2.2'

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
         end
    end
  end
end

  

end
