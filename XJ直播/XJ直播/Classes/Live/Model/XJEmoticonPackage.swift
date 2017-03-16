//
//  XJEmoticonPackage.swift
//  XJ直播
//
//  Created by Paul on 2016/12/19.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

 // MARK: 从本地加载的是哪个 Plist 文件
class XJEmoticonPackage {

    // MARK: 定义一个数组,用来保存所有的模型
   lazy var emoticons : [XJEmoticonModel] = [XJEmoticonModel]()
    
    init(plistName: String) {
        
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil),
            let emoticonArray = NSArray(contentsOfFile: path) as? [String]
            else {
            return
        }
        
        for str in emoticonArray {
            emoticons.append(XJEmoticonModel(emoticonName: str))
        }
}





}
