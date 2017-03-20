//
//  XJFucusViewController.swift
//  XJ直播
//
//  Created by Paul on 2017/3/20.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit
private let kFucusCellID = "kFucusCellID"
class XJFucusViewController: UITableViewController {

    
    fileprivate lazy var focusVM : XJFucusViewModel = XJFucusViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadFucusData()
    }
}

extension XJFucusViewController {
    fileprivate func setupUI() {
        title = "我的关注"
//        navigationController?.navigationBar.tintColor = UIColor.white
        tableView.register(UINib(nibName: "XJFucusViewCell", bundle: nil), forCellReuseIdentifier: kFucusCellID)
//        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func loadFucusData() {
        focusVM.loadFucusData {
            self.tableView.reloadData()
        }
    }
}


// MARK:- 数据源&代理方法
extension XJFucusViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return focusVM.anchorModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kFucusCellID, for: indexPath) as! XJFucusViewCell
        
        cell.anchorViewModel = focusVM.anchorModels[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let roomVc = XJRoomViewController()
        roomVc.anchor = focusVM.anchorModels[indexPath.row]
        navigationController?.pushViewController(roomVc, animated: true)
    }
}

