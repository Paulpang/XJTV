//
//  XJGiftDigitLabel.swift
//  礼物动画
//
//  Created by Paul on 2016/12/28.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

class XJGiftDigitLabel: UILabel {

 
    override func drawText(in rect: CGRect) {
        // 1. 获取上下文
        let context = UIGraphicsGetCurrentContext()
        
        // 2. 给上下文线段设置一个宽度,通过该宽度画出文本
        context?.setLineWidth(5)
        context?.setLineJoin(.round)
        context?.setTextDrawingMode(.stroke)
        textColor = UIColor.orange
        super.drawText(in: rect)
        
        // 在画里面的内容
        context?.setTextDrawingMode(.fill)
        textColor = UIColor.white
        super.drawText(in: rect)

    }
    
    // MARK: 对外暴露一个方法,用来展示动画
    func showDigitAnimation(_ complection : @escaping () -> ())  {
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                
                self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
            
            
        }) { (isFinished) in
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: { 
                self.transform = CGAffineTransform.identity
                
            }, completion: { (isFinished) in
                complection()
            })
        }
        
        
    }
    
    
    
    
    
 

}
