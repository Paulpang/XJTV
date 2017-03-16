//
//  XJAttributedStringGenerator.swift
//  XJ直播
//
//  Created by Paul on 2016/12/26.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit
import Kingfisher

class XJAttributedStringGenerator {

}

extension XJAttributedStringGenerator {
    
    
    /// 加入或者离开房间
    ///
    /// - Parameters:
    ///   - userName:  userName
    ///   - isJoinRoom: 是否加入房间
    /// - Returns: NSAttributedString
    class func generateJoinOrLeaveRoom(_ userName : String, _ isJoinRoom: Bool) -> NSAttributedString {
        
        let roomString = "\(userName)" + (isJoinRoom ? "进入房间" : "离开房间")
        
        let roomMAttrStr = NSMutableAttributedString(string: roomString)
        roomMAttrStr.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: userName.characters.count))
        
        /*
         let attachment = NSTextAttachment()
         let font = UIFont.systemFont(ofSize: 15)
         attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
         attachment.image = UIImage(named: "room_btn_gift")
         let imageAttrStr = NSAttributedString(attachment: attachment)
         joinRoomMAttr.append(imageAttrStr)
         */

        return roomMAttrStr

    }
    
    
    /// 发送文本
    ///
    /// - Parameters:
    ///   - userName: userName
    ///   - message: message
    /// - Returns: NSMutableAttributedString
    class func generateTextMessage(_ userName: String, _ message: String) -> NSMutableAttributedString {
        
        // 1. 获取整个字符串
        let chatMessage = "\(userName): \(message)"
        // 2. 根据整个字符串创建NSMutableAttributedString
        let chatMsgMAttr = NSMutableAttributedString(string: chatMessage)
        
        // 3. 需改名称的颜色
        chatMsgMAttr.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: userName.characters.count))
        
        // 4.将所有表情匹配出来, 并且换成对应的图片进行展示
        // 4.1.创建正则表达式匹配表情 我是主播[哈哈], [嘻嘻][嘻嘻] [123444534545235]
        // 在正则表达式中 . 表示任意字符, *表示任意多个  .* 表示任意多个任意字符 ?表示只要有一个符合规则的东西,就立刻匹配出来
        // 4.1.1 创建匹配规则
        let pattern = "\\[.*?\\]"
        // 4.1.2 创建正则表达式
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return chatMsgMAttr }
        // 4.1.3 开始拼配
        /**
         1.in 里面传 在哪个字符串中进行匹配
         2.length: 里面传入的是在哪个字符串中 要匹配的范围(即在字符串中哪些字符串需要匹配)
         3.这个方法的返回值是一个数组, 然后遍历这个数组取出结果
         */
        let results = regex.matches(in: chatMessage, options: [], range: NSRange(location: 0, length: chatMessage.characters.count))
        
        // 4.2 获取表情的结果 反向遍历字符串,从后往前遍历
        for i in (0..<results.count).reversed() {
            // 匹配结果的时候从前往后取
            // 4.3 获取结果
            let result = results[i]
            // 获取当前表情的图片的名称
            let emoticonName = (chatMessage as NSString).substring(with: result.range)
            // 4.4 根据取到的字符串的结果去查找对应的图片
            guard let image = UIImage(named: emoticonName) else {
                continue
            }
            // 4.5 根据图片创建 NSTextAttachment
            let attachment = NSTextAttachment()
            attachment.image = image
            let font = UIFont.systemFont(ofSize: 15)
            attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
            
            
            let attributedStr = NSAttributedString(attachment: attachment)
            //4.6 将imageAttrStr替换到之前文本的位置
            chatMsgMAttr.replaceCharacters(in: result.range, with: attributedStr)
        }
        
        return chatMsgMAttr

        
    }
    
    class func generateGiftMessge(_ userName: String, _ giftName: String, _ giftUrl: String) -> NSMutableAttributedString {
        
        // 1. 获取赠送礼物的字符串
        let giftMsgStr = "\(userName)赠送 \(giftName)"
        // 2. 根据字符串创建一个 NSMutableAttributeString
        let sendGiftMAttrMsg = NSMutableAttributedString(string: giftMsgStr)
        // 3. 修改用户的名称
        sendGiftMAttrMsg.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: userName.characters.count))
        
        // 4. 修改礼物的名称
        let range = (giftMsgStr as NSString).range(of: giftName)
        sendGiftMAttrMsg.addAttributes([NSForegroundColorAttributeName: UIColor.red], range: range)
        
        // 5.在最后拼接上礼物的图片
        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: giftUrl) else {
            
            return sendGiftMAttrMsg
        }
        
        let attacment = NSTextAttachment()
        attacment.image = image
        let font = UIFont.systemFont(ofSize: 15)
        attacment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
        let imageAttrStr = NSAttributedString(attachment: attacment)
        
        // 6. 将imageAttrStr拼接到最后
        sendGiftMAttrMsg.append(imageAttrStr)
        
        return sendGiftMAttrMsg

        
    }
    
}
