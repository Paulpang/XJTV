//
//  XJEmoticonView.swift
//  XJ直播
//
//  Created by Paul on 2016/12/19.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

private let kEmoticonCellID = "kEmoticonCellID"
private let kEdgeMargin : CGFloat = 10
class XJEmoticonView: UIView {

    var emoticonClickCallBack: ((XJEmoticonModel) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
 // MARK: setupUI
extension XJEmoticonView {
    fileprivate func setupUI() {
        
        let style = XJTitleStyle()
        style.isShowBottomLine = true
        style.isScrollEnable = false
        
        let layout = XJPageCollectionViewLayout()
        layout.cols = 7
        layout.rows = 3
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        
        let pageView = XJPageCollectionView(frame: self.bounds, titles: ["普通","粉丝专属"], style: style, isTitleInTop: false, layout: layout)
        
        // 注册 cell
        pageView.register(nib: UINib(nibName: "XJEmoticonViewCell", bundle: nil), identifier: kEmoticonCellID)
        
        addSubview(pageView)
        
        // 设置 pageView 的属性
        pageView.dataSource = self
        pageView.delegate = self
        
    }
}
 // MARK: XJPageCollectionViewDataSource
extension XJEmoticonView: XJPageCollectionViewDataSource {
    
    func numberOfSections(in pageCollectionView: XJPageCollectionView) -> Int {
        return XJEmoticonViewModel.shareInstance.packages.count
    }
    func pageCollectionView(_ collectionView: XJPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return XJEmoticonViewModel.shareInstance.packages[section].emoticons.count

    }
    func pageCollectionView(_ pageCollectionView: XJPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellID, for: indexPath) as! XJEmoticonViewCell
        cell.emoticon = XJEmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        
        
        return cell
    }
}

 // MARK: XJPageCollectionViewDelegate
extension XJEmoticonView : XJPageCollectionViewDelegate {
    
    func pageCollectionView(_ pageCollectionView: XJPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 取出每个 cell 的模型 ,然后将模型传递给 XJChatToolsView (通过闭包)
        let emoticon = XJEmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        // 将闭包传出去
        if let emoticonClickCallBack = emoticonClickCallBack {
            emoticonClickCallBack(emoticon)
        }
        
    }
}
