//
//  XJDiscoverCollectionViewCell.swift
//  XJ直播
//
//  Created by Paul on 2017/3/14.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

class XJDiscoverCollectionViewCell: UICollectionViewCell {

    /// 观看人数
    @IBOutlet weak var onlineLabel: UILabel!
    /// 主播名称
    @IBOutlet weak var nickNameLabel: UILabel!
    /// 主播头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 是否开播
    @IBOutlet weak var liveImageView: UIImageView!
    
    
    var anchorModel: XJAnchorModel? {
        
        didSet {
            
            onlineLabel.text = "\(anchorModel?.focus)人观看"
            nickNameLabel.text = anchorModel?.name
    
            iconImageView.setImage(anchorModel?.pic51, UIImage(named: "home_pic_default"), false)
            liveImageView.isHidden = anchorModel?.live == 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
