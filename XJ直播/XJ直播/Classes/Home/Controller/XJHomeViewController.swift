//
//  XJHomeViewController.swift
//  XJ直播
//
//  Created by Paul on 2016/12/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJHomeViewController: XJBaseViewController,UIScrollViewDelegate {

    /// UISearchBar
    fileprivate lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        searchBar.placeholder = "主播昵称/房间号/链接"
        searchBar.searchBarStyle = .minimal
        // 设置输入文字的颜色
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        
        // 设置光标颜色和文字颜色一致
        searchFiled?.textColor = UIColor.black
        searchFiled?.tintColor = searchFiled?.textColor
        // 不成为第一响应者
        searchFiled?.resignFirstResponder()
        return searchBar
    
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

// MARK: - 设置UI
extension XJHomeViewController {
    
    fileprivate func setupUI(){
        
        setupNav()
        setupContentView()
        
    }
    
    private func setupContentView() {
        
        // 0.获取数据
        let homeTypes = loadTypesData()
        let titles = homeTypes.map({$0.title})
        // 1.创建内容视图
        let style = XJTitleStyle()
        style.isShowBottomLine = true
        let pageFrame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 44)
        
        var childVCs = [XJAnchorViewController]()
        for type in homeTypes {
            let anchorVC = XJAnchorViewController()
            anchorVC.homeType = type
            childVCs.append(anchorVC)
        }
        
        let scrollView = XJScrollPageView(frame: pageFrame, titles: titles, style: style, childVcs: childVCs, parentVc: self)
        
        view.addSubview(scrollView)
        
    }
    private func loadTypesData() ->[HomeStyle] {
        
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)
        let dataArray = NSArray(contentsOfFile: path!) as? [[String: Any]] ?? []
        var tempArray = [HomeStyle]()
        for dict in dataArray {
            tempArray.append(HomeStyle(dict:dict))
        }
        return tempArray
        
    }
    
    private func setupNav(){
        // 右侧Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_btn_follow"), style: .plain, target: self, action: #selector(didClickRightItem))
        // 添加TitleView
        navigationItem.titleView = searchBar
        
    }
    
}

// MARK: - 监听事件
extension XJHomeViewController {
    
    @objc fileprivate func didClickRightItem() {
        
        let vc = XJFucusViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


