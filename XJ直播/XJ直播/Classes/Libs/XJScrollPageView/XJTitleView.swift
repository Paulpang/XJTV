

//
//  XJTitleView.swift
//  XJ直播
//
//  Created by Paul on 2016/12/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

// MARK:- 定义协议
protocol XJTitleViewDelegate : class {
    func titleView(_ titleView : XJTitleView, selectedIndex index : Int)
}

class XJTitleView: UIView {

    // MARK: 对外属性
    weak var delegate : XJTitleViewDelegate?
    
    // MARK: 定义属性
    fileprivate var titles : [String]!
    fileprivate var style : XJTitleStyle!
    // 记录选中的 label 的 Index, 默认选中的是第0个位置
    fileprivate var currentIndex : Int = 0
    
    // MARK: 懒加载控件属性
    // MARK: 创建label数组用来保存创建的所有titleLabel
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.frame = self.bounds
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.scrollsToTop = false
        return scrollV
    }()
    // 底部分割线
    fileprivate lazy var splitLineView : UIView = {
        let splitView = UIView()
        splitView.backgroundColor = UIColor.lightGray
        let h : CGFloat = 0.5
        splitView.frame = CGRect(x: 0, y: self.frame.height - h, width: self.frame.width, height: h)
        return splitView
    }()
    // title 下面的指示器
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    // title的背景颜色
    fileprivate lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = 0.7
        return coverView
    }()
    
    // MARK: 计算属性
    fileprivate lazy var normalColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(self.style.normalColor)
    
    fileprivate lazy var selectedColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(self.style.selectedColor)
    
    // MARK: 自定义构造函数
    init(frame: CGRect, titles : [String], style : XJTitleStyle) {
        self.titles = titles
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

// MARK:- 设置UI界面内容
extension XJTitleView {
    fileprivate func setupUI() {
        // 0.设置自己的背景
        backgroundColor = style.titleBgColor
        
        // 1.添加Scrollview
        addSubview(scrollView)
        
        // 2.添加底部分割线
        addSubview(splitLineView)
        
        // 3.设置所有的标题Label
        setupTitleLabels()
        
        // 4.设置Label的frame
        setupTitleLabelsFrame()
        
        // 5.设置底部的滚动条(添加到 scrollView 里面因为要滚动)
        if style.isShowBottomLine {
            setupBottomLine()
        }
        
        // 6.设置遮盖的View(添加到 scrollView 里面因为要滚动)
        if style.isShowCover {
            setupCoverView()
        }
    }
    
    private func setupTitleLabels() {
        
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.tag = index
            label.text = title
            // 设置第一个的颜色为选中的颜色
            label.textColor = index == 0 ? style.selectedColor : style.normalColor
            label.font = style.font
            label.textAlignment = .center
            
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_ :)))
            label.addGestureRecognizer(tapGes)
           
            scrollView.addSubview(label)
            // 将 label 添加到数组中
            titleLabels.append(label)
            
        }
    }
    
    
    private func setupTitleLabelsFrame() {
        
        var titleX: CGFloat = 0.0
        var titleW: CGFloat = 0.0
        let titleY: CGFloat = 0.0
        let titleH : CGFloat = frame.height
        
        let count = titles.count
        
        for (index, label) in titleLabels.enumerated() {
            
            if style.isScrollEnable { // 可以滚动
                let rect = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : style.font], context: nil)
                titleW = rect.width
                if index == 0 { // 当为第一个的时候, x 距离左边的距离为间距的一班
                    titleX = style.titleMargin * 0.5
                } else {
                    // 拿到上一个 label
                    let preLabel = titleLabels[index - 1]
                    titleX = preLabel.frame.maxX + style.titleMargin
                }
                
            } else { // 不能滚动
                titleW = frame.width / CGFloat(count)
                titleX = titleW * CGFloat(index)
            }
            
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            
            // 放大的代码
            if index == 0 {
                let scale = style.isNeedScale ? style.scaleRange : 1.0
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        // 设置 scrollView 的 contentSize
        if style.isScrollEnable {
            scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }
    }
    
    fileprivate func setupBottomLine() {
        scrollView.addSubview(bottomLine)
        bottomLine.frame = titleLabels.first!.frame
        bottomLine.frame.size.height = style.bottomLineH
        bottomLine.frame.origin.y = bounds.height - style.bottomLineH
    }
    
    fileprivate func setupCoverView() {
        scrollView.insertSubview(coverView, at: 0)
        let firstLabel = titleLabels[0]
        var coverW = firstLabel.frame.width
        let coverH = style.coverH
        var coverX = firstLabel.frame.origin.x
        let coverY = (bounds.height - coverH) * 0.5
        
        if style.isScrollEnable {
            coverX -= style.coverMargin
            coverW += style.coverMargin * 2
        }
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
    }
}


// MARK:- 事件处理 
extension XJTitleView {
    @objc fileprivate func titleLabelClick(_ tap : UITapGestureRecognizer) {
        // 0.获取当前Label
        guard let currentLabel = tap.view as? UILabel else { return }
        
        // 1.如果是重复点击同一个Title,那么直接返回
        if currentLabel.tag == currentIndex { return }
        
        // 2.获取之前的Label
        let oldLabel = titleLabels[currentIndex]
        
        // 3.切换文字的颜色
        currentLabel.textColor = style.selectedColor
        oldLabel.textColor = style.normalColor
        
        // 4.保存最新Label的下标值
        currentIndex = currentLabel.tag
        
        // 5.通知contentView 进行调整位置(利用代理)
        delegate?.titleView(self, selectedIndex: currentIndex)
        
        // 6.居中显示
        contentViewDidEndScroll()
        
        // 7.调整bottomLine
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.15, animations: {
                self.bottomLine.frame.origin.x = currentLabel.frame.origin.x
                self.bottomLine.frame.size.width = currentLabel.frame.size.width
            })
        }
        
        // 8.调整比例
        if style.isNeedScale {
            oldLabel.transform = CGAffineTransform.identity
            currentLabel.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
        }
        
        // 9.遮盖移动
        if style.isShowCover {
            let coverX = style.isScrollEnable ? (currentLabel.frame.origin.x - style.coverMargin) : currentLabel.frame.origin.x
            let coverW = style.isScrollEnable ? (currentLabel.frame.width + style.coverMargin * 2) : currentLabel.frame.width
            UIView.animate(withDuration: 0.15, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }
    }
}


// MARK:- 获取RGB的值
extension XJTitleView {
    fileprivate func getRGBWithColor(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("请使用RGB方式给Title赋值颜色")
        }
        
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}

// MARK:- 对外暴露的方法
extension XJTitleView {
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (selectedColorRGB.0 - normalColorRGB.0, selectedColorRGB.1 - normalColorRGB.1, selectedColorRGB.2 - normalColorRGB.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: selectedColorRGB.0 - colorDelta.0 * progress, g: selectedColorRGB.1 - colorDelta.1 * progress, b: selectedColorRGB.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: normalColorRGB.0 + colorDelta.0 * progress, g: normalColorRGB.1 + colorDelta.1 * progress, b: normalColorRGB.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
        
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveTotalW = targetLabel.frame.width - sourceLabel.frame.width
        
        // 5.计算滚动的范围差值
        if style.isShowBottomLine {
            bottomLine.frame.size.width = sourceLabel.frame.width + moveTotalW * progress
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress
        }
        
        // 6.放大的比例
        if style.isNeedScale {
            let scaleDelta = (style.scaleRange - 1.0) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: style.scaleRange - scaleDelta, y: style.scaleRange - scaleDelta)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta, y: 1.0 + scaleDelta)
        }
        
        // 7.计算cover的滚动
        if style.isShowCover {
            coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + moveTotalW * progress) : (sourceLabel.frame.width + moveTotalW * progress)
            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + moveTotalX * progress) : (sourceLabel.frame.origin.x + moveTotalX * progress)
        }
    }
    
     // MARK: 让 title 的位置居中
    func contentViewDidEndScroll() {
        // 0.如果是不需要滚动,则不需要调整中间位置
        guard style.isScrollEnable else { return }
        
        // 1.获取获取目标的Label
        let targetLabel = titleLabels[currentIndex]
        
        // 2.计算和中间位置的偏移量
        var offSetX = targetLabel.center.x - bounds.width * 0.5
        if offSetX < 0 {
            offSetX = 0
        }
        
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offSetX > maxOffset {
            offSetX = maxOffset
        }
        
        // 3.滚动UIScrollView
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
    }
}



