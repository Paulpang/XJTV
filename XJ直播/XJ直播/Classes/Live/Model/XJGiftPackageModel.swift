//
//  XJGiftPackageModel.swift
//  XJ直播
//
//  Created by Paul on 2016/12/20.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJGiftPackageModel: BaseModel {
    
    var t: Int = 0
    var title: String = ""
    var list: [XJGiftModel] = [XJGiftModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list" {
            guard let listArray = value as? [[String : Any]] else {
                return
            }
            
            for listDict in listArray {
                list.append(XJGiftModel(dict: listDict))
            }
        }else {
            super.setValue(value, forKey: key)
        }
    
    }

}
