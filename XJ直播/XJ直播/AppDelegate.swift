//
//  AppDelegate.swift
//  XJ直播
//
//  Created by Paul on 2016/12/10.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        window = UIWindow()
        window?.rootViewController = XJMainViewController()
        
        window?.makeKeyAndVisible()
        
        
        return true
    }



}

