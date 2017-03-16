//
//  XJGiftModel.swift
//  XJ直播
//
//  Created by Paul on 2016/12/20.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJGiftModel: BaseModel {

    /// 图片
    var img2: String = ""
    
    /// 价格
    var coin: Int = 0
    
    /// 标题
    var subject: String = "" { // 标题
        didSet{
            if subject.contains("有声") {
                 subject = subject.replacingOccurrences(of: "有声", with: "")
            }
        }
    }
    
}
