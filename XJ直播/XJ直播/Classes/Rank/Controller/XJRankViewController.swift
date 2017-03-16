//
//  XJRankViewController.swift
//  XJ直播
//
//  Created by Paul on 2016/12/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJRankViewController: XJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationController?.isNavigationBarHidden = true
        
        setupUI()
      
    }

}

// MARK: - 设置 UI 界面
extension XJRankViewController {
    
    fileprivate func setupUI() {
        
        let rect = CGRect(x: 0, y: kStatusBarH, width: kScreenW, height: kScreenH - kStatusBarH)
        
        let titles = ["明星榜","富豪榜","人气榜","周星榜"]
        
        let style = XJTitleStyle()
        style.isShowBottomLine = true
        style.isScrollEnable = false
        
        var childVCs = [XJSubbankViewController]()
        for i in 0..<titles.count {
       
            let vc = i == 3 ? XJWeeklyRankViewController() : XJNomalRankViewController()
            vc.currentIndex = i
            
//            vc.view.backgroundColor = UIColor.randomColor()
            childVCs.append(vc)
            
        }
        
        let scrollPageView = XJScrollPageView(frame: rect, titles: titles, style: style, childVcs: childVCs, parentVc: self)
        
        view.addSubview(scrollPageView)
        

    }
}
