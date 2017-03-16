//
//  XJProfileHeaderView.swift
//  XJ直播
//
//  Created by Paul on 2017/3/15.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit
import SnapKit

class XJProfileHeaderView: UIView {

     // MARK: --  懒加载控件
    /// 背景图
    fileprivate lazy var backImageView : UIImageView = {
        let backImageView = UIImageView(image: UIImage(named: "profile_bgImage"))
        backImageView.contentMode = .scaleAspectFill
        backImageView.layer.masksToBounds = true
        self.addSubview(backImageView)
        
        return backImageView
    }()
    /// 背景图片上面加蒙版
    fileprivate lazy var alphaView : UIView = {
        
        let alphaView = UIView()
        alphaView.backgroundColor = UIColor(hex: "0x000000", alpha: 1.0)
        alphaView.alpha = 0.5
        self.addSubview(alphaView)
        
        return alphaView
    }()
    
    /// 头像
    fileprivate lazy var avatarImageView : UIImageView = {
        
        let avatarView = UIImageView(image: UIImage(named: "profile_bgImage"))
        avatarView.layer.cornerRadius = 45.0
        avatarView.layer.masksToBounds = true
        avatarView.layer.borderColor = UIColor(hex: "0xFFB02C")?.cgColor
        avatarView.layer.borderWidth = 2.0
        // shouldRasterize = true 会使视图渲染内容被缓存起来，下次绘制的时候可以直接显示缓存，当然要在视图内容不改变的情况下
        avatarView.layer.rasterizationScale = UIScreen.main.scale
        avatarView.layer.shouldRasterize = true
        self.addSubview(avatarView)

        return avatarView
    }()
    /// 用户名按钮
    lazy var userNameBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("点击登录", for: .normal)
        self.addSubview(btn)
        return btn
    }()
     // MARK: --  布局
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin: CGFloat = 10.0
        let hspace: CGFloat = (self.width - kScreenW) * 0.5
        
        // 背景视图
        backImageView.frame = CGRect(x: hspace, y: 0, width: kScreenW, height: self.height)
        alphaView.frame = backImageView.frame
        // 头像
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(90.0)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-20)
        }
        // 点击登录按钮
        let userNameBtnH: CGFloat = 18.0
        userNameBtn.snp.makeConstraints { (make) in
            make.height.equalTo(userNameBtnH)
            make.top.equalTo(avatarImageView.snp.bottom).offset(margin)
            make.centerX.equalTo(avatarImageView.snp.centerX)
        }

    }
    
}
