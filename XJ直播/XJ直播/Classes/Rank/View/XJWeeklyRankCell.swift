//
//  XJWeeklyRankCell.swift
//  XJ直播
//
//  Created by Paul on 2017/1/10.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

class XJWeeklyRankCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var giftNumLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    var weekly : XJWeekModel? {
        didSet {
            iconImageView.setImage(weekly?.giftAppImg, nil, true)
//            iconImageView.setImage(weekly?.giftAppImg)
            giftNameLabel.text = weekly?.giftName
            giftNumLabel.text = "本周获得 x\(weekly?.giftNum ?? 0)个"
            nickNameLabel.text = weekly?.nickname
        }
    }

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}
