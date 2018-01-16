source 'https://github.com/CocoaPods/Specs.git'
# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

# Uncomment this line if you're using Swift
use_frameworks!


target 'Flickr Images' do
    pod 'SwiftyJSON', :git => 'https://github.com/acegreen/SwiftyJSON.git', :branch => 'swift3'
    #pod 'AlamofireImage', '~> 3.1'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
