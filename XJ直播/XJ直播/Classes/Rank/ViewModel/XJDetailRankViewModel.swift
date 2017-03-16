//
//  XJDetailRankViewModel.swift
//  XJ直播
//
//  Created by Paul on 2017/1/10.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

class XJDetailRankViewModel: NSObject {

    lazy var rankModels = [XJRankModel]()

    
}

extension XJDetailRankViewModel {
    
    
    func loadDetailRankData(_ type: XJRankType, _ complection:@escaping () -> ()) {
        
        let URLString = "http://qf.56.com/rank/v1/\(type.typeName).ios"
        let parameters = ["pageSize" : 30, "type" : type.typeNum]
        NetworkTools.requestData(.get, URLString: URLString, parameters: parameters) { (result) in
            print("-->",result)
            
            // 转成字典
            guard let resultDict = result as? [String : Any] else {
                return
            }
            // 2. 取出内容
            guard let msgDict = resultDict["message"] as? [String : Any] else {
                return
            }
            // 3. 取出内容
            guard let dataArray = msgDict[type.typeName] as? [[String : Any]] else { return }
        
            // 4. 转出模型对象
            for dict in dataArray {
                self.rankModels.append(XJRankModel(dict: dict))
            }
            
            // 5. 回调
            complection()
        }
    }
}
