#
# Be sure to run `pod lib lint OnrampKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OnrampKit'
  s.version          = '0.2.0'
  s.summary          = 'Pod for integration of Onramp widget in native ios applications.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "This project contains cocoapods for integrating Onramp widget in client's native ios applications"

  s.homepage         = 'https://github.com/Buyhatke/OnrampKit.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Buyhatke' => 'pd@buyhatke.com' }
  s.source           = { :git => 'https://github.com/Buyhatke/OnrampKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '4.1'

  s.source_files = 'Classes/**/*.swift'
  
   s.resource_bundles = {
     'OnrampKit' => ['Classes/**/*.storyboard']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
