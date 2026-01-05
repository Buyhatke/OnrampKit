#
# OnrampNfc.podspec
# Optional NFC module for OnrampKit
#

Pod::Spec.new do |s|
  s.name             = 'OnrampNfc'
  s.version          = '0.3.11'
  s.summary          = 'Optional NFC support module for OnrampKit'

  s.description      = "This module provides optional NFC functionality for OnrampKit. Include this dependency only if your app needs NFC passport reading capabilities."

  s.homepage         = 'https://github.com/Buyhatke/OnrampKit.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Buyhatke' => 'pd@buyhatke.com' }
  s.source           = { :git => 'https://github.com/Buyhatke/OnrampKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '4.1'

  s.source_files = 'OnrampNfc/Classes/**/*.swift'

  # Dependency on core OnrampKit
  s.dependency 'OnrampKit', '~> 0.3.11'

  # NFC-specific dependencies
  s.vendored_frameworks = 'Frameworks/UdentifyCommons.xcframework', 'Frameworks/UdentifyNFC.xcframework'

  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(SRCROOT)/Frameworks/"'
  }
end
