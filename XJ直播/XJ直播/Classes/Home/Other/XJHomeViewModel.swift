//
//  XJHomeViewModel.swift
//  XJ直播
//
//  Created by Paul on 2016/12/13.
//  Copyright © 2016年 Paul. All rights reserved.
//  MVVM --> M(model)V(View)C(Controller网络请求/本地存储数据(sqlite)) --> 网络请求
// ViewModel : RAC/RxSwift

import UIKit

class XJHomeViewModel {
    
    // MARK: --  定义几个数组,用来保存所有的数据
   lazy var anchorModels = [XJAnchorModel]()
    
    
}

extension XJHomeViewModel {
    
    
    func loadHomeData(type: HomeStyle,index : Int,  finishedCallback : @escaping () -> ()) {
        
        NetworkTools.requestData(.get, URLString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: ["type" : type.type, "index" : index, "size" : 48]) { (json) in
            
            guard let resultDict = json as? [String : Any],
                let messageDict = resultDict["message"] as? [String : Any],
                let anchorsArray = messageDict["anchors"] as? [[String : Any]]
            else {
                return
            }
            
//            print(anchorsArray)
            
            for (index,dict) in anchorsArray.enumerated() {
                let anchor = XJAnchorModel(dict: dict)
                anchor.isEvenIndex = index % 2 == 0
                // 将所有的模型添加到数组中
                self.anchorModels.append(anchor)
            }
            finishedCallback()
        }
        
    
    }
}
