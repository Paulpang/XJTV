//
//  XJEmoticonViewCell.swift
//  XJ直播
//
//  Created by Paul on 2016/12/19.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJEmoticonViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var emoticon: XJEmoticonModel? {
        didSet {
            imageView.image = UIImage(named: (emoticon?.emoticonName)!)
        }
    }

}
