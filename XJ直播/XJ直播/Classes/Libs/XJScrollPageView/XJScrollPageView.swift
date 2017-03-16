//
//  XJScrollPageView.swift
//  XJ直播
//
//  Created by Paul on 2016/12/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

/**
 
 1. 自定义构造函数  在自定义构造函数的时候,在 super.init() 方法实现之前,所有的属性都必须有值
 2. 在响应链中,只要看到 "?."说明后面取到的类型一定是可选类型
 3. 在写函数的时候,如果有参数,在参数前面添加一个"_" 这样的目的是不需要外部参数
 
 */

import UIKit

class XJScrollPageView: UIView {

    // MARK: 定义属性
    fileprivate var titles : [String]!
    fileprivate var style : XJTitleStyle!
    fileprivate var childVcs : [UIViewController]!
    fileprivate weak var parentVc : UIViewController!
    
    fileprivate var titleView : XJTitleView!
    fileprivate var contentView : XJContentView!
    
    
    // MARK: 自定义构造函数  在自定义构造函数的时候,在 super.init() 方法实现之前,所有的属性都必须有值
    init(frame: CGRect, titles : [String], style : XJTitleStyle, childVcs : [UIViewController], parentVc : UIViewController) {
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        parentVc.automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension XJScrollPageView {
    
    fileprivate func setupUI() {
        let titleH : CGFloat = style.titleHeight
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleView = XJTitleView(frame: titleFrame, titles: titles, style : style)
        titleView.delegate = self
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView = XJContentView(frame: contentFrame, childVcs: childVcs, parentViewController: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        addSubview(contentView)
    }
}

// MARK:- 设置XJContentView的代理
extension XJScrollPageView : XJContentViewDelegate {
              
    func contentView(_ contentView: XJContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    // contentView 停止滚动的时候,调整 titleView 的位置
    func contentViewEndScroll(_ contentView: XJContentView) {
        titleView.contentViewDidEndScroll()
    }
}

// MARK:- 设置XJTitleView的代理
extension XJScrollPageView : XJTitleViewDelegate {
    func titleView(_ titleView: XJTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}
