//
//  Bundle + Extension.swift
//  命名空间和反射机制
//
//  Created by Paul on 2016/11/18.
//  Copyright © 2016年 Paul. All rights reserved.
//  封装动态获取项目的名称

import Foundation

extension Bundle {
    
    // 使用函数封装
//    func nameSpace() -> String {
//        
//        return infoDictionary?["CFBundleName"] as? String ?? ""
//        
//    }
    
    // 计算型属性  没有参数,有返回值
    var nameSpace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
}
