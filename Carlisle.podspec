#
# Be sure to run `pod lib lint Carlisle.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Carlisle'
  s.version          = '0.0.1'
  s.summary          = '登录注册模块.'


  s.description      = <<-DESC
TODO:登录注册.
                       DESC

  s.homepage         = 'https://github.com/seongbrave/Carlisle'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'seongbrave' => 'seongbrave@sina.com' }
  s.source           = { :git => 'https://github.com/seongbrave/Carlisle.git', :tag => s.version.to_s }
  s.social_media_url = 'http://seongbrave.github.io'

  s.ios.deployment_target = '8.0'
  s.swift_version = "4.2"
  s.source_files = 'Carlisle/Classes/**/*{.swift}'
  
  s.dependency 'Bella', '~> 0.0.4'
  
  s.resource_bundles = {
      'Carlisle' => ['Carlisle/Assets/*{.storyboard,.xcassets}']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
