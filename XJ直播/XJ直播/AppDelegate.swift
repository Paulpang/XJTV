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
        // 创建数据库对象
        setupFocusDB()
        
        window = UIWindow()
        window?.rootViewController = XJMainViewController()
        
        window?.makeKeyAndVisible()
        
        
        return true
    }

}

 // MARK: -- 创建数据库对象
extension AppDelegate {
    // 创建数据库对象
    fileprivate func setupFocusDB() {
        XJSqliteTools.openDB(String.documentPath + "/focus.sqlite")
        let createFocusTable = "CREATE TABLE IF NOT EXISTS t_focus ( " +
            "roomid INTEGER PRIMARY KEY, " +
            "name TEXT, " +
            "pic51 TEXT, " +
            "pic74 TEXT, " +
            "live INTEGER " +
        ");"
        XJSqliteTools.execSQL(createFocusTable)
    }

}
