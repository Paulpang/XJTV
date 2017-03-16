//
//  XJNibLoadable.swift
//  XJ直播
//
//  Created by Paul on 2016/12/14.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

/**
 在协议/结构体/枚举里面 如果要定义类方法,需要用 static 修饰
 在类里面定义类方法, 这时候用 class 修饰
 */
protocol XJNibLoadable {
    
    
}

extension XJNibLoadable where Self : UIView{
    
    static func loadFromNib(_ nibname : String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }

}
