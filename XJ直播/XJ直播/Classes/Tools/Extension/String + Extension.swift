//
//  String + Extension.swift
//  XJ直播
//
//  Created by Paul on 2017/3/20.
//  Copyright © 2017年 Paul. All rights reserved.
//

import Foundation

extension String {
    static var documentPath : String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
}
