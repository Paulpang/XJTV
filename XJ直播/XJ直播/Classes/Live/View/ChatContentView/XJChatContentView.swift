//
//  XJChatContentView.swift
//  XJ直播
//
//  Created by Paul on 2016/12/23.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

private let kChatContentViewID = "kChatContentViewID"

class XJChatContentView: UIView ,XJNibLoadable{

    @IBOutlet weak var tableView: UITableView!
    
    // 定义一个数组,用来保存所有的 message 消息
    fileprivate lazy var messages: [NSAttributedString] = [NSAttributedString]()
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 注册 cell
        
        tableView.register(UINib(nibName: "XJChatContentViewCell", bundle: nil), forCellReuseIdentifier: kChatContentViewID)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    // MARK: 给外界暴露一个函数,将外界传入的数据保存到数组当中
    func insertMessage(_ message : NSAttributedString) {
        messages.append(message)
        tableView.reloadData()
        // 将数据滚动到最底部
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

}

extension XJChatContentView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kChatContentViewID, for: indexPath) as! XJChatContentViewCell
        cell.contentLabel.attributedText = messages[indexPath.row]

        
        return cell
    }
}
