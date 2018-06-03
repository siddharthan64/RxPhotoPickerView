Pod::Spec.new do |s|
  s.name             = 'RxPhotoPickerView'
  s.version          = '0.1.0'
  s.summary          = 'Reactive Photo Picker View'
 
  s.description      = <<-DESC
Reactive Photo Picker View Description
                       DESC
 
  s.homepage         = 'https://github.com/siddharthan64/RxPhotoPickerView'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Siddharthan' => 'siddharthan64@gmail.com' }
  s.source           = { :git => 'https://github.com/siddharthan64/RxPhotoPickerView.git', :tag => 'v0.3.0' }
  s.ios.deployment_target = '11.0'
  s.source_files = 'RxPhotoPickerView/*'
  s.source_files = 'RxPhotoPickerView/RxCollectionView/*'
  s.dependency "RxSwift", "~> 4.0"
  s.dependency "RxCocoa", "~> 4.0"
  s.dependency "RxBlocking", "~> 4.0"
  s.dependency "RxTest", "~> 4.0"
  s.swift_version = '4.0'
end
