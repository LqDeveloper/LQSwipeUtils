Pod::Spec.new do |spec|
  spec.name         = 'LQSwipeUtils'
  spec.version      = '1.0.1'
  spec.license      = 'MIT'
  spec.author       = { "Quan Li" => "1083099465@qq.com" }
  spec.summary      = 'iOS轮播图,UIPageViewController基类'
  spec.homepage     = 'https://github.com/lqIphone/LQSwipeUtils'
  spec.source       = { :git => 'https://github.com/lqIphone/LQSwipeUtils.git', :tag => '1.0.1' }
  spec.source_files  = "PageViewControllerDemo/Classes/*.swift"
  spec.requires_arc = true
  spec.platform     = :ios, "9.0"
  spec.swift_version = '4.2'
end
