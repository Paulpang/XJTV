//
//  XJGiftListView.swift
//  XJ直播
//
//  Created by Paul on 2016/12/20.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

private let kEdgeMargin: CGFloat = 10.0
private let kGiftViewCellID = "kGiftViewCellID"


// MARK: 添加代理协议
protocol XJGiftListViewDelegate : NSObjectProtocol {
    
    func giftListView(giftListView: XJGiftListView , giftModel: XJGiftModel)
}


class XJGiftListView: UIView ,XJNibLoadable{

    weak var delegate : XJGiftListViewDelegate?
    
    // MARK: 控件属性
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var sendGiftBtn: UIButton!
    // 定义一个属性,用来记录点击的 IndexPath 的位置
    fileprivate var currentIndexPath : IndexPath?
    
     // MARK: 私有控件
    fileprivate var pageCollectionView : XJPageCollectionView!
    fileprivate var giftVM : XJGiftViewModel = XJGiftViewModel()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sendGiftBtn.isEnabled = false
        // 1. 初始化礼物 View 视图
        setupGiftView()
        
        // 2.加载礼物的数据
        loadGiftData()
        
    }
    
   

}
// MARK: - 加载数据
extension XJGiftListView {
    fileprivate func loadGiftData() {
        giftVM.loadGiftData {
            self.pageCollectionView.reloadData()
        }
    }
}

// MARK: - setupUI
extension XJGiftListView {
    
    fileprivate func setupGiftView() {
        
        let style = XJTitleStyle()
        style.isShowBottomLine = true
        style.isScrollEnable = false
        style.normalColor = UIColor(r: 255, g: 255, b: 255)
        style.selectedColor = UIColor(r: 255, g: 127, b: 0)
        
        let layout = XJPageCollectionViewLayout()
        layout.cols = 4
        layout.rows = 2
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        var pageViewFrame = giftView.bounds
        pageViewFrame.size.width = kScreenW
        pageCollectionView = XJPageCollectionView(frame:pageViewFrame, titles: ["热门", "高级", "豪华", "专属"], style: style, isTitleInTop: true, layout: layout)
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        
        giftView.addSubview(pageCollectionView)
        
        // 注册 cell
        
        pageCollectionView.register(nib: UINib(nibName: "XJGiftViewCell", bundle: nil), identifier: kGiftViewCellID)
       
    }
}



extension XJGiftListView : XJPageCollectionViewDataSource, XJPageCollectionViewDelegate {
    // 返回多少组
    func numberOfSections(in pageCollectionView: XJPageCollectionView) -> Int {
        
        return giftVM.giftlistData.count
        
    }
    // 返回每组多少行
    func pageCollectionView(_ collectionView: XJPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let package = giftVM.giftlistData[section]
        return package.list.count
    }
    
    // 返回每个 Item 的内容
    func pageCollectionView(_ pageCollectionView: XJPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGiftViewCellID, for: indexPath) as! XJGiftViewCell
//        cell.backgroundColor = UIColor.randomColor()
        
        cell.giftModel = giftVM.giftlistData[indexPath.section].list[indexPath.item]
        
        return cell
    }
    
    
    func pageCollectionView(_ pageCollectionView: XJPageCollectionView, didSelectItemAt indexPath: IndexPath) {

        // 1. 将赠送按钮设为可点击
        sendGiftBtn.isEnabled = true
        // 2. 记录住点击的 indexPath 为了在点击赠送按钮的时候取出点击的位置
        currentIndexPath = indexPath
    }
}


// MARK: - 监听事件
extension XJGiftListView {
    
    @IBAction func sendGiftBtnClick(_ sender: UIButton) {
        
        // 获取点击的 indexPath 的模型
        let package = giftVM.giftlistData[currentIndexPath!.section]
        
        let giftModel = package.list[currentIndexPath!.item]
        
        delegate?.giftListView(giftListView: self, giftModel: giftModel)
        
    }
}
