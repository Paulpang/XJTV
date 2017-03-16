//
//  XJNavViewController.swift
//  XJ直播
//
//  Created by Paul on 2016/12/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJNavViewController: UINavigationController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopGester()
        setupAppearanceAtr()

    }
    
    /// 重写 push 方法，所有的 push 动作都会调用此方法！
    // viewController 是被 push 的控制器，设置他的左侧的按钮作为返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_back_withtext"), style: .plain, target: self, action: #selector(popToParent))
        }
        super.pushViewController(viewController, animated: true)
    }

}

// MARK: --  设置appearance属性
extension XJNavViewController {
    
    fileprivate func setupAppearanceAtr() {
        // 1. 设置导航条上返回按钮和图片的颜色
        UINavigationBar.appearance().tintColor = UIColor(hex: "0x333333")
        // 2. 设置UIBarButtonItem的主题
        let attributes = [
            NSForegroundColorAttributeName : UIColor(hex: "0x333333"),
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
       
    }
}

 // MARK: --  设置全屏手势
extension XJNavViewController {
    
    fileprivate func setupPopGester() {
        // 1.使用运行时, 打印手势中所有属性
        guard let targets = interactivePopGestureRecognizer!.value(forKey:  "_targets") as? [NSObject] else { return }
        let targetObjc = targets[0]
        let target = targetObjc.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        
        let panGes = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(panGes)
    }
}
 // MARK: --  点击事件
extension XJNavViewController {
    @objc fileprivate func popToParent() {
        popViewController(animated: true)
    }
}

 // MARK: --  自定义btn
extension XJNavViewController {
    fileprivate func setupBackButtonWithController(vc: UIViewController ,title:String) {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 40)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.setImage(UIImage(named: "navigationbar_back_withtext"), for: .normal)
        btn.titleLabel?.textColor = UIColor(hex: "0x333333")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(popToParent), for: .touchUpInside)
        let item = UIBarButtonItem(customView: btn)
        
        vc.navigationItem.leftBarButtonItem = item
        
    }
}
