//
//  XJFucusViewCell.swift
//  XJ直播
//
//  Created by Paul on 2017/3/20.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

class XJFucusViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var liveImageView: UIImageView!
    
    var anchorViewModel: XJAnchorModel? {
        didSet{
            iconImageView.setImage(anchorViewModel?.pic51, UIImage(named:""), true)
            nickNameLabel.text = anchorViewModel?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    
    }

}
