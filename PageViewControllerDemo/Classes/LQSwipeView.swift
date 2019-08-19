//
//  LQSwipeView.swift
//  PageViewControllerDemo
//
//  Created by Quan Li on 2019/8/19.
//  Copyright © 2019 williamoneilchina. All rights reserved.
//

import UIKit

public protocol LQSwipeViewDelegate:NSObjectProtocol{
    func swipeViewBeginDragging()
    func swipeViewEndDragging()
    func swipeView(swipeAtIndex index:Int)
    func swipeView(clickAtIndex index:Int)
}


public protocol LQSwipeViewDataSource:NSObjectProtocol{
    func swipeViewPageCount()->Int
    func swipeView(contentView:UIView,viewAtIndex index:Int)
}



open class LQSwipeView<ContentViewType:UIView>: UIScrollView,UIScrollViewDelegate{
    
    private let ViewTag = 10000
    
    open var leftView:ContentViewType
    open var centerView:ContentViewType
    open var rightView:ContentViewType
    
    open var tapGesture:UITapGestureRecognizer
    
    open var loop:Bool = false
    open var timeInterval:TimeInterval = 0
    private var timer:Timer?
    
    open var clickEnable = false {
        didSet{
            addGesture()
        }
        
    }
    
    public var  currentIndex = 0
    
    public weak var swipeDelegate:LQSwipeViewDelegate?
    public weak var swipeDataSource:LQSwipeViewDataSource?{
        didSet{
            initContentView()
        }
    }
    public convenience init(itemWidth:CGFloat){
        self.init(frame:CGRect.init(x: 0, y: 0, width: itemWidth, height: 0))
    }
    
    public override init(frame: CGRect) {
        leftView = ContentViewType.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        centerView = ContentViewType.init(frame: CGRect.init(x: frame.size.width, y: 0, width: frame.size.width, height: frame.size.height))
        rightView = ContentViewType.init(frame: CGRect.init(x: frame.size.width * 2, y: 0, width: frame.size.width, height: frame.size.height))
        tapGesture = UITapGestureRecognizer.init()
        super.init(frame: frame)
        addSubview(leftView)
        addSubview(centerView)
        addSubview(rightView)
        
        tapGesture.addTarget(self, action: #selector(clickView))
        
        leftView.autoresizingMask = [.flexibleLeftMargin,.flexibleHeight]
        centerView.autoresizingMask = [.flexibleLeftMargin,.flexibleHeight]
        rightView.autoresizingMask = [.flexibleLeftMargin,.flexibleHeight]
        
        
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        delegate = self
        contentSize = CGSize.init(width: frame.size.width * 3, height: frame.size.height)
        contentOffset = CGPoint.init(x: bounds.size.width, y: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGesture(){
        if clickEnable{
            centerView.addGestureRecognizer(tapGesture)
        }else{
            centerView.removeGestureRecognizer(tapGesture)
        }
    }
    
    @objc func clickView(){
        swipeDelegate?.swipeView(clickAtIndex:currentIndex)
    }
    
    
    func startLoop(){
        guard loop else{
            return
        }
        
        if timer != nil {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(selectNextPage(timer:)), userInfo: nil, repeats: true)
    }
    
    func stopLoop(){
        if timer == nil {
            return
        }
        timer?.invalidate()
        timer = nil
    }
    
    @objc func selectNextPage(timer:Timer) {
        setContentOffset(CGPoint.init(x: bounds.size.width * 2, y: 0), animated: true)
    }
    
    // MARK:UIScrollViewDelegate
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopLoop()
        swipeDelegate?.swipeViewBeginDragging()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startLoop()
        swipeDelegate?.swipeViewEndDragging()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateViews()
        swipeDelegate?.swipeView(swipeAtIndex: currentIndex)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateViews()
        swipeDelegate?.swipeView(swipeAtIndex: currentIndex)
    }
}


extension LQSwipeView{
    
    func initContentView() {
        var leftIndex = 0,centerIndex = 0,rightIndex = 0
        guard let pageCount = swipeDataSource?.swipeViewPageCount() else{
            return
        }
        if pageCount <= 0{
            leftIndex = -1
            centerIndex = -1
            rightIndex = -1
        }else if pageCount == 1{
            leftIndex = 0
            centerIndex = 0
            rightIndex = 0
            isScrollEnabled = false
        }else if pageCount == 2{
            leftIndex = 1
            centerIndex = 0
            rightIndex = 1
        }else if pageCount >= 3{
            leftIndex = pageCount - 1
            centerIndex = 0
            rightIndex = 1
        }
        
        leftView.tag = leftIndex + ViewTag
        centerView.tag = centerIndex + ViewTag
        rightView.tag = rightIndex + ViewTag
        
        swipeDataSource?.swipeView(contentView: leftView, viewAtIndex: leftIndex)
        swipeDataSource?.swipeView(contentView: centerView, viewAtIndex: centerIndex)
        swipeDataSource?.swipeView(contentView: rightView, viewAtIndex: rightIndex)
        startLoop()
    }
    
    
    
    func updateViews(){
        let flag = getFlag()
        let leftIndex = checkIndex(viewTag: leftView.tag + flag)
        let centerIndex = checkIndex(viewTag: centerView.tag + flag)
        let rightIndex = checkIndex(viewTag: rightView.tag + flag)
        
        swipeDataSource?.swipeView(contentView: leftView, viewAtIndex: leftIndex)
        swipeDataSource?.swipeView(contentView: centerView, viewAtIndex: centerIndex)
        swipeDataSource?.swipeView(contentView: rightView, viewAtIndex: rightIndex)
        
        leftView.tag = leftIndex + ViewTag
        centerView.tag = centerIndex + ViewTag
        rightView.tag = rightIndex + ViewTag
        currentIndex = centerIndex
        contentOffset = CGPoint.init(x: bounds.size.width, y: 0)
    }
    
    public func getFlag()->Int{
        var flag = 0
        let index = contentOffset.x / bounds.size.width;
        if (index == 0) {
            flag = -1;
        }else if(index == 2){
            flag = 1;
        }
        return flag
    }
    
    public func checkIndex(viewTag:Int)->Int{
        guard let pageCount = swipeDataSource?.swipeViewPageCount() else{
            return 0
        }
        let index = viewTag  - ViewTag
        if index < 0 {
            return pageCount - 1
        }else if index >= pageCount{
            return 0
        }
        return index
    }
}

