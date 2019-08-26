//
//  LQSwipeDemoView.swift
//  PageViewControllerDemo
//
//  Created by Quan Li on 2019/8/26.
//  Copyright © 2019 williamoneilchina. All rights reserved.
//

import UIKit

class LQSwipeDemoView: LQSwipeView<UIView> {
    var imageArray:[UIImage?]?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.timeInterval = 3
        self.loop = true
        self.swipeDataSource = self
        self.swipeDelegate = self
        self.startLoop()
    }
    
    
}

extension LQSwipeDemoView:LQSwipeViewDelegate{
    func swipeViewBeginDragging() {
    }
    
    func swipeViewEndDragging() {
    }
    
    func swipeView(swipeAtIndex index: Int) {
    }
    
    func swipeView(clickAtIndex index: Int) {
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

