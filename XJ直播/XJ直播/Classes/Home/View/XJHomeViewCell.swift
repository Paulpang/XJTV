//
//  XJHomeViewCell.swift
//  XJ直播
//
//  Created by Paul on 2016/12/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJHomeViewCell: UICollectionViewCell {

    // MARK: 控件属性
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var liveImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var onlinePeopleLabel: UIButton!
    
    
     // MARK: -- 定义属性
    var anchorModel : XJAnchorModel? {
        didSet {
            albumImageView.setImage((anchorModel?.isEvenIndex)! ? anchorModel?.pic74 : anchorModel?.pic51, UIImage(named: "home_pic_default"), false)
//            albumImageView.setImage((anchorModel?.isEvenIndex)! ? anchorModel?.pic74 : anchorModel?.pic51, "home_pic_default")
            liveImageView.isHidden = anchorModel?.live == 0
            nickNameLabel.text = anchorModel?.name
            onlinePeopleLabel.setTitle(" " + "\(anchorModel?.focus ?? 0)", for: .normal)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
