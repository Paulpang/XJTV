//
//  XJChatToolsView.swift
//  XJ直播
//
//  Created by Paul on 2016/12/14.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit

// MARK: 添加代理协议
protocol XJChatToolsViewDelegate : class {
    
    func chatToolsView(chatToolsView : XJChatToolsView, message : String)
}


class XJChatToolsView: UIView, XJNibLoadable {

    weak var delegate : XJChatToolsViewDelegate?
    

     // MARK: 属性
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
 
     // MARK: 懒加载控件
    fileprivate lazy var emoticonBtn: UIButton = {
        let btn =  UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        btn.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        btn.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        btn.addTarget(self, action: #selector(emoticonBtnClick), for: .touchUpInside)
        
        return btn
    }()
    fileprivate lazy var emoticonView: XJEmoticonView = XJEmoticonView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 250))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }
    
    // 当 textField 里面有内容的时候,设置按钮可点击 获取 textField 的 Editing Changed 这个属性
    @IBAction func textFieldDidEdit(_ sender: UITextField) {
        sendBtn.isEnabled = sender.text!.characters.count != 0

    }
    
}

// MARK: - setupUI
extension XJChatToolsView {
    fileprivate func setupUI() {
        
        // 0.测试: 让textFiled显示`富文本`
        /*
         let attrString = NSAttributedString(string: "I am fine", attributes: [NSForegroundColorAttributeName : UIColor.green])
         let attachment = NSTextAttachment()
         attachment.image = UIImage(named: "[大哭]")
         let attrStr = NSAttributedString(attachment: attachment)
         inputTextField.attributedText = attrStr
         */
        
        // 1.初始化inputView中rightView
        inputTextField.rightView = emoticonBtn
        inputTextField.rightViewMode = .always
        inputTextField.allowsEditingTextAttributes = true
        
        // 2.设置emotionView的闭包(weak当对象销毁值, 会自动将指针指向nil)
        // weak var weakSelf = self
        emoticonView.emoticonClickCallBack = { [weak self] emoticon in
            print(emoticon.emoticonName)
            
            // 1.判断是否是删除按钮, 如果是删除按钮,清除内容
            if emoticon.emoticonName == "delete-n" {
                self?.inputTextField.deleteBackward()
                return
            }
            
            // 2. 获取光标的位置
            guard let range = self?.inputTextField.selectedTextRange else {
                return
            }
            // 将光标的位置的内容替换成要添加的 emoticon 图标
            self?.inputTextField.replace(range, withText: emoticon.emoticonName)
            
            
            
        }
    }
}

// MARK: - 监听事件
extension XJChatToolsView {
    
   
    
    @IBAction func sendMessage(_ sender: UIButton) {
        print("sendMessage")
        // 1.获取inputTextField内容
        guard let message = inputTextField.text else {
            return
        }
        
        // 2.清空inputTextField内容,并将按钮设为可点击
        inputTextField.text = ""
        sender.isEnabled = false
        
        // 3. 将文本内容通过代理传递给控制器,然后发送给服务器
        delegate?.chatToolsView(chatToolsView: self, message: message)
    }
    
    @objc fileprivate func emoticonBtnClick(_ btn: UIButton) {
        print("点击切换键盘")
        btn.isSelected = !btn.isSelected
        
        // 切换键盘步骤
        // 0.切换键盘之前先记录光标的位置
        let range = inputTextField.selectedTextRange
        
        // 1.先取消键盘的第一响应者
        inputTextField.resignFirstResponder()
        
        // 2.判断 textField的 inputView 是否有值,如果有值,设置为 nil.如果没有值,设置自定义键盘
        if inputTextField.inputView == nil {
            inputTextField.inputView = emoticonView
        }else {
            inputTextField.inputView = nil
        }
    
        // 3.再让键盘成为第一响应者
        inputTextField.becomeFirstResponder()
        
        // 3.将切换键盘之前的位置重新恢复
        inputTextField.selectedTextRange = range
        
    }
}
