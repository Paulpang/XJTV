//
//  XJGiftViewCell.swift
//  XJ直播
//
//  Created by Paul on 2016/12/20.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJGiftViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    
    var giftModel : XJGiftModel? {
        didSet {
            iconImageView.setImage(giftModel?.img2, UIImage(named: "room_btn_gift"), true)
//            iconImageView.setImage(giftModel?.img2, "room_btn_gift")
            subjectLabel.text = giftModel?.subject
            priceLabel.text = "\(giftModel?.coin ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedView = UIView()
        selectedView.layer.cornerRadius = 5
        selectedView.layer.masksToBounds = true
        selectedView.layer.borderColor = UIColor.orange.cgColor
        selectedView.layer.borderWidth = 1
        selectedView.backgroundColor = UIColor.black
        
        selectedBackgroundView = selectedView
        
    }
    
    /**
     Swift 中重写frame 的 setter 方法的写法
     */
//    override var frame: CGRect {
//        didSet{
//            var newFrame = frame
//            newFrame.origin.x  += 10
//            newFrame.origin.y  += 10
//            newFrame.size.width -= newFrame.origin.x * 2
//            newFrame.size.height -= newFrame.origin.x * 2
//    
//            super.frame = newFrame
//        }
//    }
//    
//    
    

}
