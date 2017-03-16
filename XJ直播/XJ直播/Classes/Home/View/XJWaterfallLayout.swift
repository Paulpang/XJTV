//
//  XJWaterfallLayout.swift
//  XJ直播
//
//  Created by Paul on 2016/12/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit


@objc protocol WaterfallLayoutDataSource : class {
    
    /// 返回哪一列的高度
    func waterfallLayout(_ layout : XJWaterfallLayout, indexPath : IndexPath) -> CGFloat
    /// 返回多少列
    @objc optional func numberOfColsInWaterfallLayout(_ layout : XJWaterfallLayout) -> Int
}


class XJWaterfallLayout: UICollectionViewFlowLayout {

    // MARK: 对外提供属性
    weak var dataSource : WaterfallLayoutDataSource?
    
    // MARK: 定义一个数组,用来保存所有的UICollectionViewLayoutAttributes
    fileprivate lazy var attrsArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    //
    fileprivate var totalHeight : CGFloat = 0
    // 定义一个数组,保存当前所有 item 的高度
    fileprivate lazy var colHeights : [CGFloat] = {
        let cols = self.dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        // 取出所有的 item的个高度
        var colHeights = Array(repeating: self.sectionInset.top, count: cols)
        return colHeights
    }()
    fileprivate var maxH : CGFloat = 0
    fileprivate var startIndex = 0

}

/**
 分析:
    每个item都对应一个UICollectionViewLayoutAttributes, item的位置是由UICollectionViewLayoutAttributes来决定的
 */
// MARK: 准备布局(重写 prepare 方法)
extension XJWaterfallLayout {
    override func prepare() {
        super.prepare()
        
        // 0.获取item的个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        // 1.获取列数
        let cols = dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        
        // 2.计算Item的宽度
        let itemW = (collectionView!.bounds.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing) / CGFloat(cols)
        
        // 3. 给每个 Item 创建一个UICollectionViewLayoutAttributes
        for i in startIndex..<itemCount {
            // 1.设置每一个Item位置相关的属性
            let indexPath = IndexPath(item: i, section: 0)
            
            // 2.根据位置创建Attributes属性
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 3.随机一个高度
            guard let height = dataSource?.waterfallLayout(self, indexPath: indexPath) else {
                fatalError("请设置数据源,并且实现对应的数据源方法")
            }
            
            // 4.取出最小列的位置
            var minH = colHeights.min()!  // 取出最小的Height的高度
            let index = colHeights.index(of: minH)!  // 取出最小高度的index
            minH = minH + height + minimumLineSpacing
            colHeights[index] = minH
            
            // 5.设置attrs的frame
            let itemX: CGFloat = self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * CGFloat(index)
            let itemY: CGFloat = minH - height - self.minimumLineSpacing

            attrs.frame = CGRect(x: itemX, y: itemY, width: itemW, height: height)
            
            // 6.将所有的attrs保存到数组中
            attrsArray.append(attrs)
        }
        
        // 4.记录最大值
        maxH = colHeights.max()!
        
        // 5.给startIndex重新复制
        startIndex = itemCount
    }
}

// MARK: 返回准备好的所有布局
extension XJWaterfallLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
}

// MARK: 设置 contentSize
extension XJWaterfallLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxH + sectionInset.bottom - minimumLineSpacing)
    }

}

