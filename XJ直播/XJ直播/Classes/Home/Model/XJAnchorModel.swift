//
//  XJAnchorModel.swift
//  XJ直播
//
//  Created by Paul on 2016/12/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJAnchorModel: BaseModel {
    
    var roomid : Int = 0
    var name : String = ""
    var pic51 : String = ""
    var pic74 : String = ""
    var live : Int = 0 // 是否在直播
    var push : Int = 0 // 直播显示方式
    var focus : Int = 0 // 关注数
    
    var uid : String = ""
    
    var isEvenIndex : Bool = false

    
}


extension XJAnchorModel {
    func inserIntoDB() {
        // 1.拼接插入语句
        let insertSQL = "INSERT INTO t_focus (roomid, name, pic51, pic74, live) VALUES (\(roomid), '\(name)', '\(pic51)', '\(pic74)', \(live));"
        
        // 2.执行语句
        if XJSqliteTools.execSQL(insertSQL) {
            print("插入成功")
        } else {
            print("插入失败")
        }
    }
    
    func deleteFromDB() {
        // 1.拼接删除语句
        let deleteSQL = "DELETE FROM t_focus WHERE roomid = \(roomid);"
        
        // 2.执行语句
        if XJSqliteTools.execSQL(deleteSQL) {
            print("删除成功")
        } else {
            print("删除失败")
        }
    }
}

