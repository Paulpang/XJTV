//
//  XJSocket.swift
//  XJClient
//
//  Created by Paul on 2016/12/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

protocol XJSocketDelegate : class {
    func socket(_ socket : XJSocket, joinRoom user : UserInfo)
    func socket(_ socket : XJSocket, leaveRoom user : UserInfo)
    func socket(_ socket : XJSocket, chatMsg : ChatMessage)
    func socket(_ socket : XJSocket, giftMsg : GiftMessage)
}

class XJSocket {
    weak var delegate : XJSocketDelegate?
    
    fileprivate var tcpClient : TCPClient
    
    fileprivate var userInfo : UserInfo.Builder = {
        let userInfo = UserInfo.Builder()
        userInfo.name = "XJ\(arc4random_uniform(10))"
        userInfo.level = 20
        userInfo.iconUrl = "icon\(arc4random_uniform(5))"
        return userInfo
    }()
    
    init(addr : String, port : Int) {
        tcpClient = TCPClient(addr: addr, port: port)
    }
}



// MARK: - 对外暴露的方法
extension XJSocket {
     // MARK: 判断是否连接上服务器
    func connectServer() -> Bool {
        return tcpClient.connect(timeout: 5).0
    }
    
    // MARK: 开始读取消息信息
    func startReadMsg() {
        DispatchQueue.global().async {
            while true {
                guard let lMsg = self.tcpClient.read(4) else {
                    continue
                }
                // 1.读取长度的data
                let headData = Data(bytes: lMsg, count: 4)
                var length : Int = 0
                (headData as NSData).getBytes(&length, length: 4)
                
                // 2.读取类型
                guard let typeMsg = self.tcpClient.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type : Int = 0
                (typeData as NSData).getBytes(&type, length: 2)
                print(type)
                
                // 2.根据长度, 读取真实消息
                guard let msg = self.tcpClient.read(length) else {
                    return
                }
                let data = Data(bytes: msg, count: length)
                
                // 3.处理消息
                DispatchQueue.main.async {
                    self.handleMsg(type: type, data: data)
                }
            }
        }
    }
    
    fileprivate func handleMsg(type : Int, data : Data) {
        switch type {
        case 0, 1:
            let user = try! UserInfo.parseFrom(data: data)
            type == 0 ? delegate?.socket(self, joinRoom: user) : delegate?.socket(self, leaveRoom: user)
        case 2:
            let chatMsg = try! ChatMessage.parseFrom(data: data)
            delegate?.socket(self, chatMsg: chatMsg)
        case 3:
            let giftMsg = try! GiftMessage.parseFrom(data: data)
            delegate?.socket(self, giftMsg: giftMsg)
        default:
            print("未知类型")
        }
    }
}



extension XJSocket {
    
     // MARK: 加入房间
    func sendJoinRoom() {
        // 1.获取消息的长度
        let msgData = (try! userInfo.build()).data()
        
        // 2.发送消息
        sendMsg(data: msgData, type: 0)
    }
      // MARK: 离开房间
    func sendLeaveRoom() {
        // 1.获取消息的长度
        let msgData = (try! userInfo.build()).data()
        
        // 2.发送消息
        sendMsg(data: msgData, type: 1)
    }
      // MARK: 发送文本消息
    func sendTextMsg(message : String) {
        // 1.创建TextMessage类型
        let chatMsg = ChatMessage.Builder()
        chatMsg.user = try! userInfo.build()
        chatMsg.text = message
        
        // 2.获取对应的data
        let chatData = (try! chatMsg.build()).data()
        
        // 3.发送消息到服务器
        sendMsg(data: chatData, type: 2)
    }
      // MARK: 发送礼物信息
    func sendGiftMsg(giftName : String, giftURL : String, giftCount : Int) {
        // 1.创建GiftMessage
        let giftMsg = GiftMessage.Builder()
        giftMsg.user = try! userInfo.build()
        giftMsg.giftname = giftName
        giftMsg.giftUrl = giftURL
        giftMsg.giftcount = Int32(giftCount)
        
        // 2.获取对应的data
        let giftData = (try! giftMsg.build()).data()
        
        // 3.发送礼物消息
        sendMsg(data: giftData, type: 3)
    }
      // MARK: 添加心跳包
    func sendHeartBeat() {
        // 1.获取心跳包中的数据
        let heartString = "I am is heart beat;"
        let heartData = heartString.data(using: .utf8)!
        
        // 2.发送数据
        sendMsg(data: heartData, type: 100)
    }
    
    private func sendMsg(data : Data, type : Int) {
        // 1.将消息长度, 写入到data
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)
        
        // 2.消息类型
        var tempType = type
        let typeData = Data(bytes: &tempType, count: 2)
        
        // 3.发送消息
        let totalData = headerData + typeData + data
        tcpClient.send(data: totalData)
    }
}

