//
//  ViewController.swift
//  XJServer
//
//  Created by Paul on 2016/12/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var showLabel: NSTextField!
    fileprivate lazy var serverMgr : ServerManager = ServerManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    /// 开启服务器
    @IBAction func startServerBtn(_ sender: NSButton) {
        serverMgr.startRunning()
        showLabel.stringValue = "服务器已经开启ing"
        
    }
    /// 关闭服务器
    @IBAction func closeServerBtn(_ sender: NSButton) {
        
        serverMgr.stopRunning()
        showLabel.stringValue = "服务器未开启"
    }

}

