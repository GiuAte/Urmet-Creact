#
# Be sure to run `pod lib lint PlugUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'PlugUI'
  s.version          = '0.1.5'
  s.summary          = 'PlugUI urmet'

  s.homepage         = "https://www.urmet.com"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Silvio fosso' => 'silviofosso72@gmail.com' }
  s.source           = { :git => 'http://gitlab.urmet.com/appunica/urmetuiframework_ios.git' }

  s.ios.deployment_target = '14.0'
  s.source_files = 'PlugUI/Classes/**/*'
  s.resource = 'PlugUI/Assets/**/*'
  s.dependency 'UserSdk'
  
  end

