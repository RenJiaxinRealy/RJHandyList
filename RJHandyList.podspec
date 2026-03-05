

Pod::Spec.new do |s|
  s.name             = 'RJHandyList'
  s.version          = '0.1.1'
  s.summary          = 'A Swift utility for making UITableView easier to use.'

  s.description      = <<-DESC
  RJHandyList is a Swift utility library that simplifies UITableView usage with a clean,
  modular approach. It supports MVVM architecture, dynamic lists, and easy cell configuration.
                       DESC

  s.homepage         = 'https://github.com/RenJiaxinRealy'
  # s.screenshots     = 'www.example.com/screenshots/1', 'www.example.com/screenshots/2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RenJiaxinRealy' => '927453211@qq.com' }
  s.source           = { :git => 'git@github.com:RenJiaxinRealy/RJHandyList.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'RJHandyList/**/*.{swift}'
end
