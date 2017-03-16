//
//  XJTextViewController.swift
//  XJ直播
//
//  Created by Paul on 2017/3/16.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

class XJTextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", style: .plain, target: self, action: #selector(nextVC))
    }

    @objc private func nextVC(){
        let vc = XJTextViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
 
}
