//
//  XJGiftMessageModel.swift
//  礼物动画
//
//  Created by Paul on 2016/12/29.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJGiftMessageModel: NSObject {
    
    var senderName : String = ""
    var senderURL : String = ""
    var giftName : String = ""
    var giftURL : String = ""
    
    
    init(senderName : String, senderURL : String, giftName : String, giftURL : String) {
        self.senderName = senderName
        self.senderURL = senderURL
        self.giftName = giftName
        self.giftURL = giftURL
    }

}
