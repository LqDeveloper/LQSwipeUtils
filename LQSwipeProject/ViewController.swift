//
//  ViewController.swift
//  PageViewControllerDemo
//
//  Created by Quan Li on 2019/8/16.
//  Copyright © 2019 williamoneilchina. All rights reserved.
//

import UIKit

class ViewController: LQPageViewController {
    var controllers = [UIViewController]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pageOne = PageOneViewController()
        let pageTwo = PageTwoViewController()
        let pageThree = PageThreeViewController()
        controllers.append(pageOne)
        controllers.append(pageTwo)
        controllers.append(pageThree)
        pages.append(contentsOf: controllers)
        loop = false
        pageDelegate = self
        isScrollViewEnable = true
        selectPage(0)
    }
    
    
}


extension ViewController:LQPageViewControllerDelegate{
    func pageViewControllerDidSwitchTo(viewController:UIViewController,pageIndex: Int,direction:LQPageScrollDirection) {
        print(viewController,pageIndex,direction)
    }
    
    func pageViewControllerDidScroll(pageOffset: CGFloat,direction:LQPageScrollDirection) {
        print(pageOffset,direction)
    }
    func pageViewControllerReset(viewController: UIViewController) {
       
    }
    
    func pageViewControllerStartScroll() {
        print("开始滚动")
    }
    
    func pageViewControllerEndScroll() {
        print("停止滚动")
    }
}


