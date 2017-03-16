//
//  XJBannersController.swift
//  XJ直播
//
//  Created by Paul on 2017/3/14.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

class XJBannersController: UIViewController {

    /// webView
    fileprivate lazy var webView : UIWebView = UIWebView()
    
    var urlString : String?
    var titleString: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = (titleString ?? "")
        
        print(urlString ?? "")
        webView.frame = view.bounds
        webView.backgroundColor = UIColor.white
        view.addSubview(webView)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

    }
}

// MARK: --  加载数据
extension XJBannersController {
    fileprivate func loadData() {
        print(urlString ?? "")
        let url = URL(string: urlString!)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
}
