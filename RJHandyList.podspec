#
# Be sure to run `pod lib lint RJHandyList.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RJHandyList'
  s.version          = '0.1.0'
  s.summary          = 'A Swift utility for making UITableView easier to use.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  RJHandyList is a Swift utility library that simplifies UITableView usage with a clean,
  modular approach. It supports MVVM architecture, dynamic lists, and easy cell configuration.
                       DESC

  s.homepage         = 'https://github.com/RenJiaxinRealy/RJHandyList'
  # s.screenshots     = 'www.example.com/screenshots/1', 'www.example.com/screenshots/2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RenJiaxinRealy' => '927453211@qq.com' }
  s.source           = { :git => 'git@github.com:RenJiaxinRealy/RJHandyList.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'RJHandyListDemo/RJHandyListDemo/RJHandyList/**/*.{h,m,swift}'

  # s.resource_bundles = {
  #   'RJHandyList' => ['RJHandyList/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
