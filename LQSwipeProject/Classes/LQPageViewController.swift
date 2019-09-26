//
//  LQPageViewController.swift
//  PageViewControllerDemo
//
//  Created by Quan Li on 2019/8/16.
//  Copyright © 2019 williamoneilchina. All rights reserved.
//

import UIKit

public protocol LQPageViewControllerDelegate: NSObjectProtocol {
    func pageViewControllerDidSwitchTo(pageIndex: Int)
    func pageViewControllerDidScroll(pageOffset: CGFloat)
}


open class LQPageViewController: UIPageViewController {
    open var pages = [UIViewController]()
    open var currentPage = 0
    open var loop = false
    open var scrollView:UIScrollView?
    open  var isScrollViewEnable = true{
        didSet{
            self.scrollView?.isScrollEnabled = self.isScrollViewEnable
        }
    }
    
    open weak var pageDelegate:LQPageViewControllerDelegate?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupPageVC()
    }
    
    private func setupPageVC(){
        self.delegate = self
        self.dataSource = self
        //        只有Transition Stype 是 Scroll 时，才能获取到scroll
        guard transitionStyle == .scroll else {
            return
        }
        for view in self.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
                self.scrollView = scrollView
                break
            }
        }
    }
    
    
    public func select(index: Int, animated: Bool = true) {
        if index >= 0 && index < pages.count {
            let prevPage = self.currentPage
            let direction: UIPageViewController.NavigationDirection = (index >= prevPage) ? .forward : .reverse
            let vc = self.pages[index]
            setViewControllers([vc], direction: direction, animated: animated, completion: { (completed) in
                self.currentPage = index
            })
        }
    }
    
    public func selectNextPage(animated: Bool = true) {
        self.select(index: self.currentPage + 1, animated: animated)
    }
    
    public  func selectPreviousPage(animated: Bool = true) {
        self.select(index: self.currentPage - 1, animated: animated)
    }
}

extension LQPageViewController:UIPageViewControllerDelegate{
    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {return}
        guard let vcs =  pageViewController.viewControllers,let first = vcs.first else {
            return
        }
        self.currentPage = self.pages.firstIndex(of: first)!
        pageDelegate?.pageViewControllerDidSwitchTo(pageIndex: self.currentPage)
    }
}
extension LQPageViewController:UIPageViewControllerDataSource{
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard pages.count > 0 else {
            return nil
        }
        if loop {
            let currentPage = pages.firstIndex(of: viewController)!
            let previousPage = (currentPage - 1) < 0 ? pages.count - 1 : currentPage - 1
            return pages[previousPage]
        } else {
            let previousPage = pages.firstIndex(of: viewController)! - 1
            return previousPage < 0 || previousPage >= pages.count ? nil : pages[previousPage]
        }
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard pages.count > 0 else {
            return nil
        }
        if loop {
            let currentPage = pages.firstIndex(of: viewController)!
            let nextPage = (currentPage + 1) > pages.count - 1 ? 0 : currentPage + 1
            return pages[nextPage]
            
        } else {
            let nextPage = pages.firstIndex(of: viewController)! + 1
            return nextPage >= pages.count ? nil : pages[nextPage]
        }
    }
    
}

extension LQPageViewController:UIScrollViewDelegate{
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        let offsetFactor = (point.x - scrollView.bounds.size.width) / scrollView.bounds.size.width
        pageDelegate?.pageViewControllerDidScroll(pageOffset: CGFloat(self.currentPage) + offsetFactor)
    }
}
