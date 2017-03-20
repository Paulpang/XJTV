//
//  XJFucusViewModel.swift
//  XJ直播
//
//  Created by Paul on 2017/3/20.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

class XJFucusViewModel: XJHomeViewModel {

}


extension XJFucusViewModel {
    
    func loadFucusData(completion: () -> ()) {
        
        let dataArray = XJSqliteTools.querySQL("SELECT * FROM t_focus;")
        
        for dict in dataArray {
            self.anchorModels.append(XJAnchorModel(dict: dict))
        }
        
        completion()
    }
}
