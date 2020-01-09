Pod::Spec.new do |spec|
  spec.name         = 'LQSwipeUtils'
  spec.version      = '1.2.7'
  spec.license      = 'MIT'
  spec.author       = { "Quan Li" => "1083099465@qq.com" }
  spec.summary      = 'LQSwipeUtils,无限轮播View,UIPageViewController基类'
  spec.homepage     = 'https://github.com/LqDeveloper/LQSwipeUtils'
  spec.source       = { :git => 'https://github.com/LqDeveloper/LQSwipeUtils.git', :tag => '1.2.7' }
  spec.source_files  = "LQSwipeProject/Classes/*.swift"
  spec.requires_arc = true
  spec.platform     = :ios, "9.0"
  spec.swift_version = '5.0'
end
