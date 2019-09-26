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
        loop = true
        pageDelegate = self
        isScrollViewEnable = true
        select(index: 0, animated: true)
    }
    
    
}


extension ViewController:LQPageViewControllerDelegate{
    func pageViewControllerDidScroll(pageOffset: CGFloat) {
//        print(pageOffset)
    }
    func pageViewControllerDidSwitchTo(pageIndex: Int) {
        print(pageIndex)
    }
}


