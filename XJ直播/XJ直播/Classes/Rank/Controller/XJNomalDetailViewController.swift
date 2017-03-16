//
//  XJNomalDetailViewController.swift
//  XJ直播
//
//  Created by Paul on 2017/1/11.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

private let kDetailCellId = "kDetailCellId"

class XJNomalDetailViewController: UIViewController {

    
    var rankType: XJRankType
    // MARK: 懒加载控件
     fileprivate lazy var detailRankVM: XJDetailRankViewModel = XJDetailRankViewModel()
    fileprivate lazy  var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor(colorLiteralRed: 245, green: 245, blue: 245, alpha: 1.0)
        tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        
        tableView.register(UINib(nibName: "XJDetailRankCell", bundle: nil), forCellReuseIdentifier: kDetailCellId)
        return tableView

    }()
    
    init(rankType: XJRankType) {
        
        self.rankType = rankType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        loadData()
   
    }
    
}

// MARK: - 加载数据
extension XJNomalDetailViewController {
    func loadData() {
       detailRankVM.loadDetailRankData(rankType) { 
        
        self.tableView.reloadData()
        }
    
    }
}
// MARK: - 设置 UI 界面
extension XJNomalDetailViewController {
    
    fileprivate func setupUI() {
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension XJNomalDetailViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailRankVM.rankModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kDetailCellId, for: indexPath) as! XJDetailRankCell
        
        cell.rankModel = detailRankVM.rankModels[indexPath.row]
        cell.rankNum = indexPath.row
        
        return cell
    }
    
    
}
