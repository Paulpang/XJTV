//
//  ServerManager.swift
//  Server
//
//  Created by 小码哥 on 2016/12/11.
//  Copyright © 2016年 xmg. All rights reserved.
//  192.168.33.252

import Cocoa

class ServerManager: NSObject {
    fileprivate lazy var serverSocket : TCPServer = TCPServer(addr: "0.0.0.0", port: 7878)
    
    fileprivate var isServerRunning : Bool = false
    fileprivate lazy var clientMrgs : [ClientManager] = [ClientManager]()
}

extension ServerManager {
    func startRunning() {
        // 1.开启监听
        serverSocket.listen()
        isServerRunning = true
        
        // 2.开始接受客户端
        DispatchQueue.global().async {
            while self.isServerRunning {
                if let client = self.serverSocket.accept() {
                    DispatchQueue.global().async {
                        self.handlerClient(client)
                    }
                }
            }
        }
    }
    
    func stopRunning() {
        isServerRunning = false
    }
    
}

extension ServerManager {
    fileprivate func handlerClient(_ client : TCPClient) {
        // 1.用一个ClientManager管理TCPClient
        let mgr = ClientManager(tcpClient: client)
        mgr.delegate = self
        
        // 2.保存客户端
        clientMrgs.append(mgr)
        
        // 3.用client开始接受消息
        mgr.startReadMsg()
    }
}

extension ServerManager : ClientManagerDelegate {
    func sendMsgToClient(_ data: Data) {
        for mgr in clientMrgs {
            mgr.tcpClient.send(data: data)
        }
    }
    
    func removeClient(_ client: ClientManager) {
        guard let index = clientMrgs.index(of: client) else { return }
        clientMrgs.remove(at: index)
    }
}
