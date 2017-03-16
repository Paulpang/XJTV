//
//  XJAnchorViewController.swift
//  XJ直播
//
//  Created by Paul on 2016/12/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

private let kEdgeMargin : CGFloat = 8
private let kCollectionCellId = "kCollectionCellId"

class XJAnchorViewController: XJBaseViewController {

    // MARK: 懒加载属性
    fileprivate lazy var animImageView: UIImageView = { [unowned self] in
        let imageView = UIImageView(image: UIImage(named: "img_loading_1"))
        imageView.center = self.view.center
        imageView.animationImages = [UIImage(named: "img_loading_1")!, UIImage(named: "img_loading_2")!]
        imageView.animationDuration = 0.5
        imageView.animationRepeatCount = LONG_MAX
        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        return imageView
        }()

    
    // MARK: 对外属性
    var homeType : HomeStyle?

    // 定义homeVM对象
    fileprivate lazy var homeVM : XJHomeViewModel = XJHomeViewModel()
    /// collectionView
    fileprivate lazy var collectionView : UICollectionView =  {
        
        let layout = XJWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        layout.minimumLineSpacing = kEdgeMargin
        layout.minimumInteritemSpacing = kEdgeMargin
        layout.dataSource = self

        let collectionView = UICollectionView(frame: self.view.bounds , collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        // 解决collectionViewCell底部cell显示不全的问题
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        // 注册cell
        collectionView.register(UINib(nibName: "XJHomeViewCell", bundle: nil), forCellWithReuseIdentifier: kCollectionCellId)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData(index: 0)
        
    }
}

// MARK: - 请求数据
extension XJAnchorViewController {
    fileprivate func loadData(index : Int) {
        homeVM.loadHomeData(type: homeType!, index: index, finishedCallback: {
            self.collectionView.reloadData()
            // 3.数据请求完成
            self.loadDataFinished()
        })
        
    }
}
// MARK: - setupUI
extension XJAnchorViewController {
    
    fileprivate func setupUI() {
        view.addSubview(collectionView)
        // 1. 隐藏contentView
        collectionView.isHidden = true
        // 2. 添加执行动画的UIImageView
        view.addSubview(animImageView)
        // 3. 开始执行动画
        animImageView.startAnimating()
        // 4. 设置背景颜色
        animImageView.backgroundColor = UIColor(r: 250, g: 250, b: 250)
    }
    func loadDataFinished() {
        // 1. 停止动画
        animImageView.stopAnimating()
        // 2. 隐藏animImageView
        animImageView.isHidden = true
        // 3. 显示contentView
        collectionView.isHidden = false
    }

}


// MARK: - WaterfallLayoutDataSource
extension XJAnchorViewController : WaterfallLayoutDataSource {
    
    func numberOfColsInWaterfallLayout(_ layout: XJWaterfallLayout) -> Int {
        return 2
    }
    func waterfallLayout(_ layout: XJWaterfallLayout, indexPath: IndexPath) -> CGFloat {

        return indexPath.item % 2 == 0 ? kScreenW * 2 / 3 : kScreenW * 0.5
    }
}

// MARK: - UICollectionViewDataSource,UICollectionViewDelegate
extension XJAnchorViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.anchorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: kCollectionCellId, for: indexPath) as! XJHomeViewCell
        cell.backgroundColor = UIColor.randomColor()
        cell.anchorModel = homeVM.anchorModels[indexPath.item]
        
        // 解决上拉刷新刷新数据的时候,重复请求数据的问题,在拉倒最后一条数据的时候,手动请求数据,不请求所有数据
        if indexPath.item == homeVM.anchorModels.count - 1 {
             loadData(index: homeVM.anchorModels.count)
        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let roomVC = XJRoomViewController()
        roomVC.anchor = homeVM.anchorModels[indexPath.item]
        navigationController?.pushViewController(roomVC, animated: true)
        
    }
    
    
}

