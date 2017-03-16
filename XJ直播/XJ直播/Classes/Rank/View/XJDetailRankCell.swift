//
//  XJDetailRankCell.swift
//  XJ直播
//
//  Created by Paul on 2017/1/10.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

class XJDetailRankCell: UITableViewCell {

    
    @IBOutlet weak var rankNumBtn: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var liveImageView: UIImageView!
    
    var rankNum : Int = 0 {
        didSet {
            if rankNum < 3 {
                rankNumBtn.setTitle("", for: .normal)
                rankNumBtn.setImage(UIImage(named: "ranking_icon_no\(rankNum + 1)"), for: .normal)
            } else {
                rankNumBtn.setImage(nil, for: .normal)
                rankNumBtn.setTitle("\(rankNum + 1)", for: .normal)
            }
        }
    }

    
    var rankModel : XJRankModel? {
        didSet {
            iconImageView.setImage(rankModel?.avatar, nil, true)
//            iconImageView.setImage(rankModel?.avatar)
            nickNameLabel.text = rankModel?.nickname
            liveImageView.isHidden = rankModel?.isInLive == 0
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }


}
