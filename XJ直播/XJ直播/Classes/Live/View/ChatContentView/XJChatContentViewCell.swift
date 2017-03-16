//
//  XJChatContentViewCell.swift
//  XJ直播
//
//  Created by Paul on 2016/12/23.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJChatContentViewCell: UITableViewCell {

    
    @IBOutlet weak var contentLabel: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        selectionStyle = .none
    }

  }
