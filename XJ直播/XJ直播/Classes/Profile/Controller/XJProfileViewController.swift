//
//  XJProfileViewController.swift
//  XJ直播
//
//  Created by Paul on 2016/12/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

private let kProfileCellID = "kProfileCellID"
private let kHeaderViewH: CGFloat = 288


 // MARK: --  列表标题

private let kMeSubScribe   = "我的订阅"
private let kMePlayHistory = "播放历史"

private let kMeHasBuy      = "我的已购"
private let kMeWallet      = "我的钱包"

private let kMeStore    = "XJ直播商城"
private let kMeStoreOrder  = "我的商城订单"
private let kMeCoupon      = "我的优惠券"
private let kMeGameenter   = "游戏中心"
private let kMeSmartDevice = "智能硬件设备"

private let kMeFreeTrafic  = "免流量服务"
private let kMeFeedBack    = "意见反馈"
private let kEditMyInfo    = "编辑资料"
private let kMeSetting     = "设置"

// 免流量服务 链接
private let kFreeTraficURL = "http://hybrid.ximalaya.com/api/telecom/index?app=iting&device=iPhone&impl=com.gemd.iting&telephone=%28null%29&version=5.4.27"

class XJProfileViewController: XJBaseViewController {

    // MARK:- 普通属性
    var lightFlag: Bool = true
    
     // MARK: --  懒加载
    
    /// 列表标题数组
   fileprivate lazy var titleArray:[[String]] = {
        return [[kMeSubScribe, kMePlayHistory],
                [kMeHasBuy, kMeWallet],
                [kMeStore, kMeStoreOrder, kMeCoupon, kMeGameenter, kMeSmartDevice],
                [kMeFreeTrafic, kMeFeedBack, kEditMyInfo, kMeSetting]]
    }()
    /// 列表图标数组
    lazy var imageArray:[[String]] = {
        return [["mine_follow", "mine_money"],
                ["mine_fanbao", "mine_bag"],
                ["mine_money", "mine_money", "mine_bag", "mine_fanbao", "mine_follow"],
                ["mine_fanbao", "mine_bag", "mine_edit","mine_set"]]
    }()

    
    /// tableView
    fileprivate lazy var tableView : UITableView = {
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: self.view.height - 49)
        let tableView = UITableView(frame: rect, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kHeaderViewH))
        tableView.addSubview(self.headerView)
        
        return tableView
    }()
    
    /// headerView
    fileprivate lazy var headerView : XJProfileHeaderView = {
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kHeaderViewH)
        let headerView = XJProfileHeaderView(frame: rect)
        headerView.backgroundColor = UIColor.red
        
        return headerView
    }()
     // MARK: --  视图生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        // 让tableView在状态栏下方不偏移
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(tableView)
        tableView.rowHeight = 44.0
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kProfileCellID)
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    // MARK:- 设置状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if lightFlag {
            return .lightContent
        } else {
            return .default
        }
    }
    /// 状态栏
    lazy var statusBackView: UIView = { [unowned self] in
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 20))
        view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        self.view.addSubview(view)
        self.view.bringSubview(toFront: view)
        return view
        }()
}

// MARK: --  UITableView的数据源和代理方法
extension XJProfileViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let subTitle = titleArray[indexPath.section]
        let imageArr = imageArray[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kProfileCellID, for: indexPath)
        
        
        cell.textLabel?.text = subTitle[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        cell.imageView?.image = UIImage(named: imageArr[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let title = cell?.textLabel?.text else {
            return
        }
        
        if title == kMeFreeTrafic { // 免流量
            jump2FreeTraficService()
        }else if title == kMeSetting { // 设置
            jump2SettingVC()
        }
    }
    
}

// MARK:- 界面跳转
extension XJProfileViewController {
    // MARK: 免流量服务
    fileprivate func jump2FreeTraficService() {
        
        let serviceVC = XJBannersController()
        serviceVC.urlString = kFreeTraficURL
        serviceVC.titleString = "免流量包"
        serviceVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(serviceVC, animated: true)
    }
    // MARK: 设置
    fileprivate func jump2SettingVC() {
        let settingVc = XJSettingViewController()
        settingVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingVc, animated: true)
    }

}

// MARK:- UIScrollView的代理方法
extension XJProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 {
            headerView.frame = CGRect(x: offsetY * 0.5, y: offsetY, width: kScreenW - offsetY, height: kHeaderViewH - offsetY)
        }
        
        // 随时设置状态栏样式
        if offsetY < 200.0 {
            statusBackView.alpha = 0.0
            setStatusBarStyle(isLight: true)
        } else if offsetY >= 200 && offsetY < 220 {
            let alpha: CGFloat = (offsetY - 200) / 20.0
            view.bringSubview(toFront: statusBackView)
            statusBackView.alpha = alpha
        } else {
            statusBackView.alpha = 1.0
            view.bringSubview(toFront: statusBackView)
            setStatusBarStyle(isLight: false)
        }
    }
    // 设置状态栏样式
    func setStatusBarStyle(isLight: Bool) {
        if isLight && lightFlag == false {
            lightFlag = true
            setNeedsStatusBarAppearanceUpdate() // 更新状态栏样式
        } else if !isLight && lightFlag == true {
            lightFlag = false
            setNeedsStatusBarAppearanceUpdate()
        }
    }
}
