//
//  XJEmitterable.swift
//  XJ直播
//
//  Created by Paul on 2016/12/14.
//  Copyright © 2016年 Paul. All rights reserved.
//  面向协议开发

import UIKit

protocol XJEmitterable {
    
}

extension XJEmitterable where Self : UIViewController {
    
    func startEmittering(_ point : CGPoint) {
        
        // 1. 创建发射器
        let emitter = CAEmitterLayer()
        
        // 2. 设置发射器的位置
        emitter.emitterPosition = point
        
        // 3. 开启三维效果
        emitter.preservesDepth = true
        
        // 4. 创建粒子,并且设置粒子的相关属性
        var cells = [CAEmitterCell]()
        for i in 0..<10 {
            // 4.1 创建粒子cell
            let cell = CAEmitterCell()
            
            // 4.2 设置例子速度
            cell.velocity = 150
            cell.velocityRange = 100
            
            // 4.3 设置粒子的大小
            cell.scale = 0.7
            cell.scaleRange = 0.3
            
            // 4.4.设置粒子方向
            cell.emissionLongitude = CGFloat(-M_PI_2)
            cell.emissionRange = CGFloat(M_PI_2 / 6)
            
            // 4.5 设置粒子的存活时间
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            
            // 4.6 设置粒子的旋转方向
            cell.spin = CGFloat(M_PI_2)
            cell.spinRange = CGFloat(M_PI_2 / 2)
            
            // 4.7 设置粒子每秒弹出的个数
            cell.birthRate = 2
            
            // 4.8 设置例子的展示图片
            cell.contents = UIImage(named: "good\(i)_30x30")?.cgImage
            
            // 4.9 添加到数组中
            cells.append(cell)
            
        }
        
        // 5 将粒子设置到发射器中
        emitter.emitterCells = cells
        
        // 6. 将发射器的layer添加到父layer中
        view.layer.addSublayer(emitter)
        
    }
    
    func stopEmittering() {
        
        // 遍历layer的所有子layer,然后取出类型为CAEmitterLayer的layer,并将它从父layer中移除
        
//        for layer in view.layer.sublayers! {
//            if layer.isKind(of: CAEmitterLayer.self) {
//                layer.removeFromSuperlayer()
//            }
//        }
        
        view.layer.sublayers?.filter({$0.isKind(of: CAEmitterLayer.self)}).first?.removeFromSuperlayer()
        
    }
    
}
