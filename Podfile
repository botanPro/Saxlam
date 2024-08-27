# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end

target 'sharktest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

 source 'https://github.com/CocoaPods/Specs.git'


  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'CRRefresh'
  pod 'FSPagerView'
  pod 'SDWebImage'
  pod 'PureLayout'
  pod 'MBRadioCheckboxButton'
  pod "CollieGallery"
  pod 'Cosmos'
  
  pod 'Firebase/Messaging'
  pod 'Firebase'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Analytics'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Firebase/DynamicLinks'
  
  
  pod 'ValidationTextField'
  
  pod 'HMSegmentedControl'
  pod 'MXSegmentedPager'
  pod 'AZDialogView'
  pod 'UIView-Shimmer', '~> 1.0'
  pod "Slider2"
  pod "BSImagePicker", "~> 2.8"
  pod 'ScrollingPageControl'
  pod 'DropDown'
  pod 'OTPTextField'
  pod 'MHLoadingButton'
  pod 'PhoneNumberKit', '~> 3.3'
  
  pod 'Toast-Swift', '~> 5.0.1'
  
  pod 'EmptyDataSet-Swift', '~> 5.0.0'
  
  pod "AAShimmerView"
  
  pod 'SKPhotoBrowser'
  
  pod 'YoutubePlayer-in-WKWebView', '~> 0.2.0'
  
  pod 'FCAlertView'

  pod 'ShimmerLabel', '~> 1.0'
  
  pod 'FlipLabel'
  
  pod 'NVActivityIndicatorView'
  pod 'Drops', :git => 'https://github.com/omaralbeik/Drops.git', :tag => '1.5.0'
  pod 'EmptyDataSet-Swift', '~> 5.0.0'
  
  pod 'GIFImageView'
  pod 'SCLAlertView'

  pod 'SKPhotoBrowser'
  pod "PullToDismissTransition"
  
  pod 'ScrollableSegmentedControl', '~> 1.5.0'

  pod "PageControls/SnakePageControl"
  pod "PageControls/FilledPageControl"
  pod "PageControls/PillPageControl"
  pod "PageControls/ScrollingPageControl"
  pod 'FFLabel'
  pod 'PDFReader'
  
  pod "Thorsignia_InternetCheck"

  pod 'AEOTPTextField'

  pod "SwiftChart"
  target 'sharktestTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'sharktestUITests' do
    # Pods for testing
  end

end


