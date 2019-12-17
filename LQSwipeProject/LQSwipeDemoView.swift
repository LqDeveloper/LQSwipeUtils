//
//  LQSwipeDemoView.swift
//  PageViewControllerDemo
//
//  Created by Quan Li on 2019/8/26.
//  Copyright © 2019 Quan Li All rights reserved.
//

import UIKit

class LQSwipeDemoView: LQSwipeView<UIView> {
    var imageArray:[UIImage?]?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loop = true
        self.clickEnable = true
        self.swipeDataSource = self
        self.swipeDelegate = self
        self.startLoop()
    }
}

extension LQSwipeDemoView:LQSwipeViewDelegate{
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

extension LQSwipeDemoView:LQSwipeViewDataSource{
    func swipeViewPageCount() -> Int {
        return 3
    }
    
    func swipeView(contentView: UIView, viewAtIndex index: Int) {
        switch index {
        case 0:
            contentView.backgroundColor = .red
        case 1:
            contentView.backgroundColor = .green
        case 2:
            contentView.backgroundColor = .cyan
        default: break
            
        }
    }
}

