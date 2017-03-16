//
//  XJWeeklyRankViewModel.swift
//  XJ直播
//
//  Created by Paul on 2017/1/10.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

class XJWeeklyRankViewModel: NSObject {

     lazy var weeklyRanks : [[XJWeekModel]] = [[XJWeekModel]]()
    
}

extension XJWeeklyRankViewModel {
    
    func loadWeeklyRankData(_ rankType : XJRankType, _ completion : @escaping () -> ()) {
        let URLString = "http://qf.56.com/activity/star/v1/rankAll.ios"
        let signature = rankType.typeNum == 1 ? "b4523db381213dde637a2e407f6737a6" : "d23e92d56b1f1ac6644e5820eb336c3e"
        let ts = rankType.typeNum == 1 ? "1480399365" : "1480414121"
        let parameters : [String : Any] = ["imei" : "36301BB0-8BBA-48B0-91F5-33F1517FA056", "pageSize" : 30, "signature" : signature, "ts" : ts, "weekly" : rankType.typeNum - 1]
        
        NetworkTools.requestData(.get, URLString: URLString, parameters: parameters, finishedCallback: { result in
            // 1.转成字典
            guard let resultDict = result as? [String : Any] else { return }
            
            // 2.取出内容
            guard let msgDict = resultDict["message"] as? [String : Any] else { return }
            
            // 3.取出主播的数据
            if let anchorDataArray = msgDict["anchorRank"] as? [[String : Any]] {
                self.addDataToWeeklyRanks(anchorDataArray)
            }
            
            // 4.取出粉丝的数据
            if let fansDataArray = msgDict["fansRank"] as? [[String : Any]] {
                self.addDataToWeeklyRanks(fansDataArray)
            }
            
            // 5.回调
            completion()
        })
    }
    
    private func addDataToWeeklyRanks(_ dataArray : [[String : Any]]) {
        var ranks = [XJWeekModel]()
        for dict in dataArray {
            ranks.append(XJWeekModel(dict: dict))
        }
        weeklyRanks.append(ranks)
    }

}
