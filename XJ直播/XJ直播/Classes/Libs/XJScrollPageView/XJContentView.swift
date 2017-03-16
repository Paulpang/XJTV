//
//  XJContentView.swift
//  XJ直播
//
//  Created by Paul on 2016/12/12.
//  Copyright © 2016年 Paul. All rights reserved.
//


/**
 
 目前 self. 不能省略的情况
    1> 在方法中和其他的标识符有歧义(重名)的情况
    2> 在闭包(block)中 self. 不能省略
    3> 在懒加载里面直接创建控件,控件里面用到 self, 不能省略
 
 
 */
import UIKit

@objc protocol XJContentViewDelegate : class {
    
    func contentView(_ contentView : XJContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
    
    @objc optional func contentViewEndScroll(_ contentView : XJContentView)
}

private let kContentCellID = "kContentCellID"



class XJContentView: UIView {

    // MARK: 对外属性
    weak var delegate : XJContentViewDelegate?
    
    // MARK: 定义属性
    fileprivate var childVcs : [UIViewController]!
    fileprivate weak var parentVc : UIViewController!
    fileprivate var isForbidScrollDelegate : Bool = false
    // MARK: 记录contentView在将要滑动的那一刻的偏移量, 后续用来判断是左滑还是右滑
    fileprivate var startOffsetX : CGFloat = 0
    
    // MARK: 控件属性
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.frame = self.bounds
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        // 注册cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.backgroundColor = UIColor.clear
        
        return collectionView
    }()
    
    // MARK: 构造函数
    init(frame: CGRect, childVcs : [UIViewController], parentViewController : UIViewController) {
        
        self.childVcs = childVcs
        self.parentVc = parentViewController
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:- 设置界面内容
extension XJContentView {
    fileprivate func setupUI() {
        
        // MARK: 1.将所有的控制器添加到父控制器中
        for vc in childVcs {
            parentVc.addChildViewController(vc)
        }
        
        // 2.添加UICollectionView
        addSubview(collectionView)
    }
}


// MARK:- 设置UICollectionView的数据源
extension XJContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        // MARK: 只有在子控制器添加到父控制器之后才能将子控制器的View添加到父控制器的View上面 
        // 2.在添加素所有的子控制器的View之前,先移除所有的子控制器的View
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        // 3.将所有的子控制器View添加到contentView当中
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}


// MARK:- 设置UICollectionView的代理
extension XJContentView : UICollectionViewDelegate {
    
    // 开始拖拽的时候,记录这时候的偏移量,后面判断左滑还是右滑
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0.判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        // 0.1 判断和开始的时候偏移量是否一致
        guard startOffsetX != scrollView.contentOffset.x else {
            return
        }
        
        // 1.定义获取需要的数据
        var progress : CGFloat = 0.0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count { // 判断越界
                targetIndex = childVcs.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
           
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count { // 判断越界
                sourceIndex = childVcs.count - 1
            }
        }
        
        // 3.将progress/sourceIndex/targetIndex传递给titleView
        delegate?.contentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    // scollView 停止减速的时候处理事情
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.contentViewEndScroll?(self)
    }
    // 停止拖拽的湿乎乎处理事情
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.contentViewEndScroll?(self)
        }
    }
}

// MARK:- 对外暴露的方法
extension XJContentView {
    func setCurrentIndex(_ currentIndex : Int) {
        
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        
        // 2.滚动正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}

