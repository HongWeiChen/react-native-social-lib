
Pod::Spec.new do |s|
  s.name         = "RNSocialManager"
  s.version      = "1.0.0"
  s.summary      = "RNSocialManager"
  s.description  = <<-DESC
                  RNSocialManager
                   DESC
  s.homepage     = "https://www.npmjs.com/package/react-native-social-lib"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNSocialManager.git", :tag => "master" }
  s.source_files = "*.{h,m}", "SDK/*/*.{h,m}"
  s.requires_arc = true
  s.vendored_libraries = 'SDK/*/*.a'
  s.vendored_frameworks = 'SDK/*/*.framework'
  s.frameworks   = 'UIKit','CFNetwork','CoreFoundation','CoreTelephony','SystemConfiguration','CoreGraphics','Foundation','Security','CoreLocation','AssetsLibrary'
  s.libraries       = 'z','resolv'

  s.dependency "React"

end

  
