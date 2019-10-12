//
//  PageOneViewController.swift
//  PageViewControllerDemo
//
//  Created by Quan Li on 2019/8/16.
//  Copyright © 2019 williamoneilchina. All rights reserved.
//

import UIKit
import SnapKit
class PageOneViewController: UIViewController {
//    var swipeView = LQSwipeView.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 300))
    var swipeView = LQSwipeView.init(frame: CGRect.zero,direction: .horizontal_right)
    
    var verticalSwipeView = LQSwipeView.init(frame: CGRect.zero,direction: .vertical_down)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(swipeView)
        
        swipeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(300)
        }
        
        
        swipeView.swipeDelegate = self
        swipeView.swipeDataSource = self
        swipeView.loop = true
        swipeView.timeInterval = 3
        swipeView.clickEnable = true
        swipeView.startLoop()
        
        
        view.addSubview(verticalSwipeView)
        
        verticalSwipeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(320)
            make.height.equalTo(300)
        }
        
        
        verticalSwipeView.swipeDelegate = self
        verticalSwipeView.swipeDataSource = self
        verticalSwipeView.loop = true
        verticalSwipeView.timeInterval = 3
        verticalSwipeView.clickEnable = true
        verticalSwipeView.startLoop()
        
    }
    
    
    
}


extension PageOneViewController:LQSwipeViewDelegate{
    func swipeViewBeginDragging() {
        print("开始拖拽")
    }
    
    func swipeViewEndDragging() {
        print("停止拖拽")
    }
    
    func swipeView(swipeAtIndex index: Int) {
        print("滚动到第\(index)个")
    }
    
    func swipeView(clickAtIndex index: Int) {
        print("点击第\(index)个")
    }
}

extension PageOneViewController:LQSwipeViewDataSource{
    func swipeViewPageCount() -> Int {
        return 3
    }
    
    func swipeView(contentView: UIView, viewAtIndex index: Int) {
        if(index == 0){
            contentView.backgroundColor = .red
        }else if index == 1{
            contentView.backgroundColor = .green
        }else if index == 2{
            contentView.backgroundColor = .blue
        }else{
            contentView.backgroundColor = .cyan
        }
        
    }
    
    
}
