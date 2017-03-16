//
//  BaseModel.swift
//  XJ直播
//
//  Created by Paul on 2016/12/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    
    override init() {
        
    }
    
    init(dict:[String: Any]) {
        super.init()
        setValuesForKeys(dict)

    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
