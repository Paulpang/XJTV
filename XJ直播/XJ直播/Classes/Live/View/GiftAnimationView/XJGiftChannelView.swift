//
//  XJGiftChannelView.swift
//  礼物动画
//
//  Created by Paul on 2016/12/28.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

/**
    思路分析 :
     当处于正在实行动画的时候,需要判断是不是同一个用户传过来的是否是同一个模型,
    如果是同一个用户 在执行同一个操作,需要将动画 Label 数字加1;
    如果是同一个用户或者不同用户 执行的不同操作,需要判断另外一个频道是否处于闲置,如果是处于闲置状态,则在另外一个频道中执行,否则将任务添加到缓存池中,等待有任务结束后,在从缓存池中取出任务来执行
 */
// 频道视图的状态
enum XJGiftChannelState {
    case idle // 空闲时候
    case animating // 正在实行动画 这个状态时候:需要判断是不是同一个用户传过来的是否是同一个模型,
    case willEnd // 动画结束,停顿3s 的状态
    case endAnimating // 消失动画状态
}

protocol XJGiftChannelViewDelegate : class {
    func giftAnimationDidCompletion(giftChannelView: XJGiftChannelView)
}

class XJGiftChannelView: UIView {
    
    // MARK: 设置代理属性
    weak var delegate: XJGiftChannelViewDelegate?

    // MARK: 控件属性
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var giftDescLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var digitLabel: XJGiftDigitLabel!
    
    
     // 定义一个属性,用来记录当前的倍数
    fileprivate var currentNumber: Int = 0
    // 定义一个缓存数据,当动画处于 animating 状态时,用来保存同一个user发送的同一个礼物
    fileprivate var cacheNumber: Int = 0
    // 定义当前频道视图的状态, 默认是空闲状态
    var state: XJGiftChannelState = .idle
    
    // 传递模型
    var giftModel: XJGiftMessageModel? {
        didSet {
            // 1.对模型进行校验
            guard let giftModel = giftModel else {
                return
            }
            
            // 2.给控件设置信息
            iconImageView.image = UIImage(named: giftModel.senderURL)
            senderLabel.text = giftModel.senderName
            giftDescLabel.text = "送出礼物：【\(giftModel.giftName)】"
            giftImageView.image = UIImage(named: giftModel.giftURL)
            
            // 3.将ChanelView弹出,将数据传递给频道视图的时候,此时的状态为正在执行动画状态
            state = .animating
            performAnimation()
        }
    }

}

 // MARK: 设置 UI
extension XJGiftChannelView {
    override func layoutSubviews() {
        super.layoutSubviews()

        bgView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.green.cgColor

    }
}

// MARK:- 对外提供的函数
extension XJGiftChannelView {
    /// 增加缓存
    func addOnceToCache() {
        // 当任务处于等待状态时,直接执行动画,动画结束后,然后再取消任务 ,然后在执行动画
        if state == .willEnd { //当任务处于正在等待任务的时候3.0s 时候
            performDigitAnimation()
            // 取消任务: 这个方法的作用是取消  self.perform(#selector(self.performEndAnimation 方法
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        } else { // 当任务不是处于在等待任务的时候,才可以在缓存池中数据+1,如何处于等待的状态,直接执行动画,就不需要讲任务添加到缓存池当中
            cacheNumber += 1
        }
    }
    
    // 从 Xib 加载视图
    class func loadFromNib() -> XJGiftChannelView {
        return Bundle.main.loadNibNamed("XJGiftChannelView", owner: nil, options: nil)?.first as! XJGiftChannelView
    }
    
    
    
}

 // MARK: 执行动画代码
/**
    思路分析: 先将 ChannelView 视图弹出,弹出后执行倍数Label的跳动动画
 */
extension XJGiftChannelView {
    
    /// 显示频道视图
    fileprivate func performAnimation() {
        digitLabel.alpha = 1.0
        digitLabel.text = " x1 "
        
        // 弹出动画
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.frame.origin.x = 0
        }) { (isFinished) in // 执行 label 的跳动动画
            // 将频道视图显示出来后,要显示数字 Label 并添加动画
            self.performDigitAnimation()
        }
    }
    
    /// 执行文字弹跳效果
    fileprivate func performDigitAnimation() {
        currentNumber += 1
        digitLabel.text = " X\(currentNumber) "
        // 在执行完 label 的弹跳动画以后,判断缓存中有没有任务,如果有缓存,执行缓存任务:将缓存-1,然后递归执行动画,至到缓存池中没有任务为止
        digitLabel.showDigitAnimation { 
            // 用户连击/ 视图等待3.0当中
            if self.cacheNumber > 0 { //说明缓存池中有等待的任务
                self.cacheNumber -= 1
                self.performDigitAnimation()
            }else {  // 执行完动画后,下一个操作是等待消失状态(3.0s 等待),这时候的状态是willEnd
                self.state = .willEnd
                self.perform(#selector(self.performEndAnimation), with: nil, afterDelay: 3.0)
            }
            
        }
    }
    /// 执行消失动画,这时候的状态为endAnimating状态
    @objc fileprivate func performEndAnimation() {
        state = .endAnimating
        UIView.animate(withDuration: 0.25, animations: { 
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0.0
            
        }) { (isFinished) in // 在动画消失后,这时候的状态为闲置状态即 : idle
            self.currentNumber = 0
            self.cacheNumber = 0
             // 清空模型数据,如果不设置,在外面判断是不是同一个模型的时候会出问题: 如果是同一个模型,需要举行执行想一个视图,如果不是同一个模型,需要将模型添加到缓存池当中,等待执行
            self.giftModel = nil
            self.frame.origin.x = -self.frame.width // 将视图的位置重新回到屏幕的最左端
            self.state = .idle
            self.digitLabel.alpha = 0.0
            
            // 动画执行完以后,将消息传递给上一个控件,告诉控制器
            self.delegate?.giftAnimationDidCompletion(giftChannelView: self)
            
        }
    }
}
