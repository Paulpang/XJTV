//
//  XJWeeklyDetailViewController.swift
//  XJ直播
//
//  Created by Paul on 2017/1/11.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

private let kWeeklyRankeCellID = "kWeeklyRankeCellID"

class XJWeeklyDetailViewController: UIViewController {

    var rankType: XJRankType
    // MARK: 懒加载控件
    fileprivate lazy var weeklyRankVM : XJWeeklyRankViewModel = XJWeeklyRankViewModel()
  
    fileprivate lazy  var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor(colorLiteralRed: 245, green: 245, blue: 245, alpha: 1.0)
        tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        
        tableView.register(UINib(nibName: "XJWeeklyRankCell", bundle: nil), forCellReuseIdentifier: kWeeklyRankeCellID)
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

extension XJWeeklyDetailViewController {
    fileprivate func loadData() {
        weeklyRankVM.loadWeeklyRankData(rankType) { 
            self.tableView.reloadData()
        }
    }
}

// MARK: - 设置 UI 界面
extension XJWeeklyDetailViewController {
    
    fileprivate func setupUI() {
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension XJWeeklyDetailViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weeklyRankVM.weeklyRanks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyRankVM.weeklyRanks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kWeeklyRankeCellID, for: indexPath) as! XJWeeklyRankCell
        
        cell.weekly = weeklyRankVM.weeklyRanks[indexPath.section][indexPath.row]
        
        return cell
    }
    
    
}
