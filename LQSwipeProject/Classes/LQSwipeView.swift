//
//  LQSwipeView.swift
//  PageViewControllerDemo
//
//  Created by Quan Li on 2019/8/19.
//  Copyright © 2019 Quan Li All rights reserved.
//

import UIKit

public protocol LQSwipeViewDelegate:NSObjectProtocol{
    func swipeViewBeginDragging()
    func swipeViewEndDragging()
    func swipeView(swipeAtIndex index:Int)
    func swipeView(clickAtIndex index:Int)
}

public extension LQSwipeViewDelegate{
    func swipeViewBeginDragging(){}
    func swipeViewEndDragging(){}
    func swipeView(swipeAtIndex index:Int){}
    func swipeView(clickAtIndex index:Int){}
}


public protocol LQSwipeViewDataSource:NSObjectProtocol{
    func swipeViewPageCount()->Int
    func swipeView(contentView:UIView,viewAtIndex index:Int)
}


public enum LQSwipeDirection:Int{
    case horizontal_left = 0   //从右往左滚动
    case horizontal_right = 1  //从左往右滚动
    case vertical_up = 2       //从下往上滚动
    case vertical_down = 3     //从上往下滚动
}


open class LQSwipeView<ContentViewType:UIView>: UIScrollView,UIScrollViewDelegate{
    private let ViewTag = 10000
    
    public var direction:LQSwipeDirection = .horizontal_left
    
    @IBInspectable var directionValue:Int{
        get{
            return direction.rawValue
        }
        set{
            direction = LQSwipeDirection.init(rawValue: newValue) ?? .horizontal_left
        }
    }
    
    public var leftView:ContentViewType
    public var centerView:ContentViewType
    public var rightView:ContentViewType
    
    public var tapGesture:UITapGestureRecognizer
    
    public var loop:Bool = false
    public var timeInterval:TimeInterval = 3
    private var timer:Timer?
    
    public var clickEnable = false {
        didSet{
            addOrRemoveGesture()
        }
    }
    
    public var  currentIndex = 0
    
    public weak var swipeDelegate:LQSwipeViewDelegate?
    public weak var swipeDataSource:LQSwipeViewDataSource?{
        didSet{
            reloadData()
        }
    }
    
    public init(frame: CGRect,direction:LQSwipeDirection = .horizontal_left) {
        self.direction = direction
        leftView = ContentViewType.init()
        centerView = ContentViewType.init()
        rightView = ContentViewType.init()
        tapGesture = UITapGestureRecognizer.init()
        super.init(frame: frame)
        makeLayout()
        initViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        leftView = ContentViewType.init(frame: CGRect.zero)
        centerView = ContentViewType.init(frame: CGRect.zero)
        rightView = ContentViewType.init(frame: CGRect.zero)
        tapGesture = UITapGestureRecognizer.init()
        super.init(coder: aDecoder)
        initViews()
    }
    
    func makeLayout(){
        if direction  == .horizontal_left || direction == .horizontal_right{
            leftView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            centerView.frame = CGRect.init(x: frame.size.width, y: 0, width: frame.size.width, height: frame.size.height)
            rightView.frame = CGRect.init(x: frame.size.width * 2, y: 0, width: frame.size.width, height: frame.size.height)
            contentSize = CGSize.init(width: frame.size.width * 3, height: frame.size.height)
            contentOffset = CGPoint.init(x: bounds.size.width, y: 0)
        }else{
            leftView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            centerView.frame = CGRect.init(x: 0, y: frame.size.height, width: frame.size.width, height: frame.size.height)
            rightView.frame = CGRect.init(x:0, y: frame.size.height * 2, width: frame.size.width, height: frame.size.height)
            contentSize = CGSize.init(width: frame.size.width, height: frame.size.height * 3)
            contentOffset = CGPoint.init(x:0, y: frame.size.height)
        }
    }
    
    public func initViews(){
        addSubview(leftView)
        addSubview(centerView)
        addSubview(rightView)
        
        tapGesture.addTarget(self, action: #selector(clickView))
        
        leftView.autoresizingMask = [.flexibleLeftMargin,.flexibleHeight]
        centerView.autoresizingMask = [.flexibleLeftMargin,.flexibleHeight]
        rightView.autoresizingMask = [.flexibleLeftMargin,.flexibleHeight]
        
        leftView.isUserInteractionEnabled = true
        centerView.isUserInteractionEnabled = true
        rightView.isUserInteractionEnabled = true
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *){
            self.contentInsetAdjustmentBehavior = .never
        }
        isPagingEnabled = true
        delegate = self
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if leftView.frame.size.width == 0{
            makeLayout()
        }
    }
    
    
    func addOrRemoveGesture(){
        if clickEnable{
            centerView.addGestureRecognizer(tapGesture)
        }else{
            centerView.removeGestureRecognizer(tapGesture)
        }
    }
    
    @objc func clickView(){
        swipeDelegate?.swipeView(clickAtIndex:currentIndex)
    }
    
    
    ///在必要的时候调用stopLoop，防止内存泄露
    public  func startLoop(){
        guard loop else{
            return
        }
        
        guard let pageCount = swipeDataSource?.swipeViewPageCount(), pageCount <= 1 else{
            return
        }
        
        if timer != nil {
            return
        }
        
        timer = Timer.init(timeInterval: timeInterval, target: self, selector: #selector(selectNextPage(timer:)), userInfo: nil, repeats: true)
        guard let tim = timer else {
            return
        }
        RunLoop.current.add(tim, forMode: .common)
    }
    
    public func stopLoop(){
        if timer == nil {
            return
        }
        timer?.invalidate()
        timer = nil
    }
    
    @objc func selectNextPage(timer:Timer) {
        if direction == .horizontal_left {
            setContentOffset(CGPoint.init(x: bounds.size.width * 2, y: 0), animated: true)
        }else if direction == .horizontal_right {
            setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }else if direction == .vertical_up {
            setContentOffset(CGPoint.init(x: 0, y: bounds.size.height * 2), animated: true)
        }else{
            setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
    }
    
    // MARK:UIScrollViewDelegate
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopLoop()
        swipeDelegate?.swipeViewBeginDragging()
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startLoop()
        swipeDelegate?.swipeViewEndDragging()
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateViews()
        swipeDelegate?.swipeView(swipeAtIndex: currentIndex)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateViews()
        swipeDelegate?.swipeView(swipeAtIndex: currentIndex)
    }
}


extension LQSwipeView{
    public func reloadData() {
        var leftIndex = 0,centerIndex = 0,rightIndex = 0
        guard let pageCount = swipeDataSource?.swipeViewPageCount() else{
            return
        }
        if pageCount <= 0{
            return
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
    }
    
    
    
    public func updateViews(){
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
        if direction == .horizontal_left || direction == .horizontal_right {
            contentOffset = CGPoint.init(x: bounds.size.width, y: 0)
        }else{
            contentOffset = CGPoint.init(x: 0, y: bounds.size.height)
        }
    }
    
    public func getFlag()->Int{
        var flag = 0
        var index:CGFloat = 0
        if direction == .horizontal_left || direction == .horizontal_right {
            index = contentOffset.x / bounds.size.width
        }else{
            index = contentOffset.y / bounds.size.height
        }
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

