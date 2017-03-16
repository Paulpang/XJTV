//
//  XJTitleStyle.swift
//  XJ直播
//
//  Created by Paul on 2016/12/12.
//  Copyright © 2016年 Paul. All rights reserved.
//  这个类的目的是用来设置 titleView 的属性,这写属性有外界来控制

import UIKit

class XJTitleStyle {
    /// 是否是滚动的Title
    var isScrollEnable : Bool = true
    /// 普通Title颜色
    var normalColor : UIColor = UIColor(r: 0, g: 0, b: 0)
    /// 选中Title颜色
    var selectedColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    /// Title字体大小
    var font : UIFont = UIFont.systemFont(ofSize: 14.0)
    /// 滚动Title的字体间距
    var titleMargin : CGFloat = 20
    /// titleView的高度
    var titleHeight : CGFloat = 44
    /// titleView的背景颜色
    var titleBgColor : UIColor = .clear
    
    /// 是否显示底部滚动条
    var isShowBottomLine : Bool = false
    /// 底部滚动条的颜色
    var bottomLineColor : UIColor = UIColor.orange
    /// 底部滚动条的高度
    var bottomLineH : CGFloat = 2
    
    
    /// 是否进行缩放
    var isNeedScale : Bool = false
    var scaleRange : CGFloat = 1.2
    
    
    /// 是否显示遮盖
    var isShowCover : Bool = false
    /// 遮盖背景颜色
    var coverBgColor : UIColor = UIColor.lightGray
    /// 文字&遮盖间隙
    var coverMargin : CGFloat = 5
    /// 遮盖的高度
    var coverH : CGFloat = 25
    /// 遮盖的宽度
    var coverW : CGFloat = 0
    /// 设置圆角大小
    var coverRadius : CGFloat = 12
}

