//
//  XJEmoticonViewModel.swift
//  XJ直播
//
//  Created by Paul on 2016/12/19.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJEmoticonViewModel {

    // 创建一个单列
    static let shareInstance : XJEmoticonViewModel = XJEmoticonViewModel()
    
    lazy var packages: [XJEmoticonPackage] = [XJEmoticonPackage]()
    
    
    init() {
        packages.append(XJEmoticonPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(XJEmoticonPackage(plistName: "QHSohuGifSort.plist"))
    }
    
}
