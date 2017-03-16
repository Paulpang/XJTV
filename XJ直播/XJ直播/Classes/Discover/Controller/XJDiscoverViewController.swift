//
//  XJDiscoverViewController.swift
//  XJ直播
//
//  Created by Paul on 2016/12/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit
import SDCycleScrollView


private let kDiscoverID = "KDiscoverID"
class XJDiscoverViewController: XJBaseViewController, SDCycleScrollViewDelegate {
    
    var bannerVM: XJCarouseViewModel = XJCarouseViewModel()
    
    // MARK: -- 懒加载
    fileprivate lazy var tableView: UITableView = UITableView()
    /// headerView
    fileprivate lazy var headerView : UIView = {

        let headerView = UIView(frame: CGRect(x: 0, y: -kScreenW * 0.4, width: kScreenW, height: kScreenW * 0.4))
        headerView.addSubview(self.scrollView)
        
        return headerView
        
    }()
    
    /// scrollView
    fileprivate lazy var scrollView : UIScrollView = {
        
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW * 0.4)
        let scrollView = UIScrollView(frame: rect)
        scrollView.contentSize = CGSize(width: kScreenW, height: kScreenW * 0.4)
        scrollView.addSubview(self.bannerView)
        
        return scrollView
    }()

    fileprivate lazy var bannerView : SDCycleScrollView = {
        
        let bannerView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW * 0.4), delegate: self, placeholderImage: nil)
        bannerView?.delegate = self
        bannerView?.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        bannerView?.pageDotColor = UIColor(white: 1.0, alpha: 0.5)
        bannerView?.currentPageDotColor = UIColor.orange

        return bannerView!
    }()

    fileprivate lazy var footerView: UIView = {
        
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: 80)
        let footerView = UIView(frame: rect)
        footerView.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame.size = CGSize(width: kScreenW * 0.5, height: 40)
        btn.center = CGPoint(x: kScreenW * 0.5, y: 40)
        btn.setTitle("换一换", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.layer.borderWidth = 0.5
        
        btn.addTarget(self, action: #selector(switchGuessAnchor), for: .touchUpInside)
        
        footerView.addSubview(btn)
        
        
        return footerView
        
    }()
    
    // MARK: --  视图生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        // 加载bannerView数据
        bannerVM.loadCarouselData {
            self.bannerView.imageURLStringsGroup = self.bannerVM.banners
            self.tableView.reloadData()
        }
    }
}

// MARK: --  SDCycleScrollViewDelegate
extension XJDiscoverViewController {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        print(index)
        let bannerVC = XJBannersController()
        bannerVC.urlString = self.bannerVM.links[index]
        bannerVC.titleString = self.bannerVM.names[index]
        navigationController?.pushViewController(bannerVC, animated: true)
    }
}

// MARK: -- 监听事件
extension XJDiscoverViewController {
    @objc fileprivate func switchGuessAnchor() {
        print("点击换一换")
        // 获取tableView上面所有显示的Cell
        let cell = tableView.visibleCells.first as? XJDiscoverCell
        cell?.reloadData()
        // 添加动画
        let offset = CGPoint(x: 0, y: kScreenW * 0.4 - 64)
        tableView.setContentOffset(offset, animated: true)
    }
}

 // MARK: --  setupUI
extension XJDiscoverViewController {
    fileprivate func setupUI() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        // headerView
        tableView.tableHeaderView = headerView
        // footerView
        tableView.tableFooterView = footerView
        tableView.rowHeight = kScreenW * 1.4
        
        view.addSubview(tableView)
        // 注册cell
        tableView.register(UINib(nibName: "XJDiscoverCell", bundle: nil) , forCellReuseIdentifier: kDiscoverID)
    }
    // 猜你喜欢
    fileprivate func setupSectionHeaderView () -> UIView {
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 40))
        sectionHeaderView.backgroundColor = UIColor.white
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 40))
        headerLabel.text = "猜你喜欢"
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.orange
        sectionHeaderView.addSubview(headerLabel)
    
        return sectionHeaderView
    }
}

// MARK: --  UITableView的数据源&代理
extension XJDiscoverViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kDiscoverID, for: indexPath) as! XJDiscoverCell

        cell.cellDidSelected = { (anchor : XJAnchorModel) in
            let liveVc = XJRoomViewController()
            liveVc.anchor = anchor
            self.navigationController?.pushViewController(liveVc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupSectionHeaderView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}











