//
//  ViewController.swift
//  XJClient
//
//  Created by Paul on 2016/12/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

/*
 1> 获取到服务器对应的IP/端口号
 2> 使用Socket, 通过IP/端口号和服务器建立连接
 3> 开启定时器, 实时让服务器发送心跳包
 4> 通过sendMsg, 给服务器发送消息: 字节流 --> headerData(消息的长度) + typeData(消息的类型) + MsgData(真正的消息)
 5> 读取从服务器传送过来的消息(开启子线程)
 */


class ViewController: UIViewController {

    fileprivate lazy var socket : XJSocket = XJSocket(addr: "0.0.0.0", port: 7878)
    
    fileprivate var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if socket.connectServer() {
            
            print("连接成功")
            
            socket.startReadMsg()
            //            socket.delegate = self
            
            timer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
        }
        
        
    }
    
    deinit {
        timer.invalidate()
        timer = nil
    }
    
    /*
     进入房间 = 0
     离开房间 = 1
     文本 = 2
     礼物 = 3
     */
    
    @IBAction func joinRoom() {
        socket.sendJoinRoom()
    }
    
    @IBAction func leaveRoom() {
        socket.sendLeaveRoom()
    }
    
    @IBAction func sendText() {
        socket.sendTextMsg(message: "这是一个文本消息")
    }
    
    @IBAction func sendGift() {
        socket.sendGiftMsg(giftName: "火箭", giftURL: "http://www.baidu.com", giftCount: 1000)
    }
    
}


extension ViewController {
    @objc fileprivate func sendHeartBeat() {
        socket.sendHeartBeat()
    }
}

