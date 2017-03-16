//
//  XJMainViewController.swift
//  XJ直播
//
//  Created by Paul on 2016/12/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.white
        setupUI()

    }

   
}


// MARK: - 设置UI界面
extension XJMainViewController {
    
    fileprivate func setupUI() {
        let array = [
            ["clsName": "XJHomeViewController", "title": "直播", "imageName": "home"],
            ["clsName": "XJRankViewController", "title": "排行", "imageName": "message_center"],
            ["clsName": "XJDiscoverViewController", "title": "发现", "imageName": "discover"],
            ["clsName": "XJProfileViewController", "title": "我的", "imageName": "profile"],
            ]
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(setupViewControllers(dict as [String : Any]))
        }
        
        viewControllers = arrayM

        
    }
    
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 字典信息[clsName,title,imageName]
    /// - Returns: UIViewController
    private func setupViewControllers(_ dict:[String : Any]) -> UIViewController {
        
        // 1.取得字典内容
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? XJBaseViewController.Type
            else {
                return UIViewController()
        }
        
        // 2.创建控制器
        let vc = cls.init()
        vc.title = title
       
        
        // 3.设置头像
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
       
        // 4. 设置 tabbar 的标题字体（大小）
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(r: 217, g: 165, b: 69)], for: .selected)
        // 系统默认是 12 号字，修改字体大小，要设置 Normal 的字体大小
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: .normal)
        // 实例化导航控制器的时候，会调用 push 方法将 rootVC 压栈
        let nav = XJNavViewController(rootViewController: vc)
        
        return nav
        
        
    }
    
    

    
}
