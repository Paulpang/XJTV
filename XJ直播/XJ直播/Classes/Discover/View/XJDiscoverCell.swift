//
//  XJDiscoverCell.swift
//  XJ直播
//
//  Created by Paul on 2017/3/14.
//  Copyright © 2017年 Paul. All rights reserved.
//

import UIKit

private let kDiscoverCollectionViewCellID = "kDiscoverCollectionViewCellID"
class XJDiscoverCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
     // MARK: --  懒加载控件
    fileprivate lazy var discoverVM: XJDiscoverContentViewModel = XJDiscoverContentViewModel()

    fileprivate var anchorData : [XJAnchorModel]?
    fileprivate var currentIndex : Int = 0
    
    var cellDidSelected : ((_ anchor : XJAnchorModel) -> ())?

    
    // MARK: --  视图生命周期
    override func awakeFromNib() {
        super.awakeFromNib()
        
        discoverVM.loadContentData { 
            self.anchorData = Array(self.discoverVM.anchorModels[self.currentIndex * 9..<(self.currentIndex + 1) * 9])
            
            self.collectionView.reloadData()
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        // 注册cell
        collectionView.register(UINib(nibName: "XJDiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kDiscoverCollectionViewCellID)

    }

    
}

 // MARK: --  给外界暴露一个接口,用来刷新数据
extension XJDiscoverCell {
    
    func reloadData() {
        currentIndex += 1
        if currentIndex > 2 { currentIndex = 0 }
        anchorData = Array(discoverVM.anchorModels[currentIndex * 9..<(currentIndex + 1) * 9])
        collectionView.reloadData()
        
    }
}

// MARK: --  UICollectionView 数据源和代理方法
extension XJDiscoverCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anchorData?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDiscoverCollectionViewCellID, for: indexPath) as! XJDiscoverCollectionViewCell
        cell.anchorModel = anchorData?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cellDidSelected = cellDidSelected {
            cellDidSelected(anchorData![indexPath.item])
        }
    }
    
}

// MARK: --  UICollectionViewFlowLayout
class XJDiscoverContentViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        let itemMargin: CGFloat = 10
        let itemW = ((collectionView?.bounds.width)! - 4 * itemMargin) / 3
        let itemH = (collectionView?.bounds.height)! / 3
        
        itemSize = CGSize(width: itemW, height: itemH)
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = itemMargin
        sectionInset = UIEdgeInsets(top: 0, left: itemMargin, bottom: 0, right: itemMargin)
        
        collectionView?.bounces = false
        
    }
}



