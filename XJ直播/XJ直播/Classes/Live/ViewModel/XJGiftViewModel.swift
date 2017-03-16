//
//  XJGiftViewModel.swift
//  XJ直播
//
//  Created by Paul on 2016/12/20.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJGiftViewModel {

    lazy var giftlistData : [XJGiftPackageModel] = [XJGiftPackageModel]()

}

extension XJGiftViewModel {
    
    func loadGiftData(finishedCallBack:@escaping () -> ())  {
        
        NetworkTools.requestData(.get, URLString: "http://qf.56.com/pay/v4/giftList.ios", parameters: ["type" : 0, "page" : 1, "rows" : 150]) { (result) in
            guard let resultDict = result as? [String : Any] else { return }
            
            guard let dataDict = resultDict["message"] as? [String : Any] else { return }
            print("---->" + "\(result)")
            for i in 0..<dataDict.count {
                guard let dict = dataDict["type\(i+1)"] as? [String : Any] else { continue }
                self.giftlistData.append(XJGiftPackageModel(dict: dict))
            }
            
            self.giftlistData = self.giftlistData.filter({ return $0.t != 0 }).sorted(by: { return $0.t > $1.t })
            
            finishedCallBack()
            
        }
    }
}
