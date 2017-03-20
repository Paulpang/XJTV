//
//  XJSqliteTools.swift
//  XJ直播
//
//  Created by Paul on 2017/3/20.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

class XJSqliteTools: NSObject {
    // 数据库指针属性
    fileprivate static var db : OpaquePointer? = nil

}

// MARK:- 打开数据库方法
extension XJSqliteTools {
    @discardableResult
    class func openDB(_ filePath : String) -> Bool {
        // 1.转化路径
        let cFilePath = filePath.cString(using: String.Encoding.utf8)!
        
        // 2.打开数据库
        return sqlite3_open(cFilePath, &db) == SQLITE_OK
    }
}

// MARK:- 执行语句方法
extension XJSqliteTools {
    @discardableResult
    class func execSQL(_ sqlString : String) -> Bool {
        // 1.将sqlString转成C语句字符串
        let cSQLString = sqlString.cString(using: String.Encoding.utf8)!
        
        // 2.执行语句
        return sqlite3_exec(db, cSQLString, nil, nil, nil) == SQLITE_OK
    }
}


// MARK:- 查询语句方法
extension XJSqliteTools {
    class func querySQL(_ sqlString : String) -> [[String : Any]] {
        // 1.创建游标(指针)
        var stmt : OpaquePointer? = nil
        
        // 2.给游标赋值
        sqlite3_prepare_v2(db, sqlString.cString(using: String.Encoding.utf8)!, -1, &stmt, nil)
        
        // 3.判断是否有下一行
        // 3.1.获取列数
        let count = sqlite3_column_count(stmt)
        
        // 3.2.定义数组
        var tempArray = [[String : Any]]()
        
        // 3.2.取出数据
        while sqlite3_step(stmt) == SQLITE_ROW {
            var dict = [String : Any]()
            for i in 0..<count {
                let key = String(cString: sqlite3_column_name(stmt, i), encoding: String.Encoding.utf8)!
                let value = sqlite3_column_text(stmt, i)
                
                let valueStr = String(cString: value!)
                
                dict[key] = valueStr
            }
            
            tempArray.append(dict)
        }
        
        return tempArray
    }
}
