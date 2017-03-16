//
//  XJDiscoverContentViewModel.swift
//  XJ直播
//
//  Created by Paul on 2017/3/14.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

class XJDiscoverContentViewModel: XJHomeViewModel {

}

extension XJDiscoverContentViewModel {
    
    func loadContentData(_ complection: @escaping () -> ()) {
        
        NetworkTools.requestData(.get, URLString: "http://qf.56.com/home/v4/guess.ios", parameters: ["count" : 27]) { (json: Any) in
            
//            print("--->\(json)")
            
            // 1.转换成字典
            guard let responseDict = json as? [String : Any] else {
                return
            }
            // 2.取出内容
            guard let msgDict = responseDict["message"] as? [String : Any] else { return }
            
            // 3.取出内容
            guard let dataArray = msgDict["anchors"] as? [[String : Any]] else { return }
            
            // 4.转成模型对象
            for dict in dataArray {
                self.anchorModels.append(XJAnchorModel(dict: dict))
            }
            // 5.回调
            complection()
        }
    }
}
