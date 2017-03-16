
//
//  XJRoomViewController.swift
//  XJ直播
//
//  Created by Paul on 2016/12/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

import UIKit
import Kingfisher
import IJKMediaFramework

private let kMoreInfoViewH : CGFloat = 90
private let kSocialShareViewH : CGFloat = 250
private let kChatToolsViewHeight : CGFloat = 44
private let kChatComtetViewHeight : CGFloat = 150
private let kgiftViewHeight : CGFloat = kScreenH * 0.5


/// 直播视图
class XJRoomViewController: XJBaseViewController, XJEmitterable {

    // MARK: 对外提供控件属性
    var anchor : XJAnchorModel?
    
    
    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var roomNumLabel: UILabel!
    @IBOutlet weak var onlineLabel: UILabel!
 
     // MARK: 懒加载聊天视图
    fileprivate lazy var chatToolsView : XJChatToolsView = XJChatToolsView.loadFromNib()
    // 懒加载礼物视图
    fileprivate lazy var giftView : XJGiftListView = XJGiftListView.loadFromNib()
    // 懒加载更多信息视图
    fileprivate lazy var moreinfoView: XJMoreInfoView = XJMoreInfoView.loadFromNib()
    // 懒加载分享视图
    fileprivate lazy var shareView: XJShareView = XJShareView.loadFromNib()
    // 懒加载 ChatContentView 视图
    fileprivate lazy var chatContentView: XJChatContentView = XJChatContentView.loadFromNib()
    fileprivate lazy var giftContainerView : XJGiftContainerView = XJGiftContainerView(frame: CGRect(x: 0, y: 100, width: 250, height: 100))
    
    // 懒加载即时通讯
    fileprivate lazy var socket : XJSocket = XJSocket(addr: "0.0.0.0", port: 7878)
    
    // 定义定时器属性
    fileprivate var heartBeatTimer: Timer?
    
    fileprivate var ijkPlayer: IJKFFMoviePlayerController?
    
    
    // MARK: 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置 UI 界面
        setupUI()
        
        // 2监听键盘的弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // 3.连接聊天服务器
        if socket.connectServer() {
            print("连接成功")
            // 3.1 开始读取信息
            socket.startReadMsg()
            // 3.2 添加心跳包
            addHeartBeatTimer()
            // 3.3 发送加入房间消息
            socket.sendJoinRoom()
            // 3.4 设置 socket 的代理
            socket.delegate = self
        }
        
        // 4.请求主播的信息
        loadAnchorLiveAddress()
        
    }
 

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 发送离开房间消息
        socket.sendLeaveRoom()
        // 关闭 ijkplayer
        ijkPlayer?.shutdown()
    }
    deinit {
        // 移除定时器
        heartBeatTimer?.invalidate()
        heartBeatTimer = nil
    }
}
// MARK:- 设置UI界面内容
extension XJRoomViewController {
    fileprivate func setupUI() {
        // 添加蒙版视图
        setupBlurView()
        // 添加底部聊天视图
        setupBottomView()
        // 添加动画视图
        view.addSubview(giftContainerView)
        // 设置数据
        setupInfo()
    }
    
    private func setupInfo(){
        
        print("------> + \(anchor?.pic74)")
        bgImageView.setImage(anchor?.pic74)
        iconImageView.setImage(anchor?.pic51)
        nickNameLabel.text = anchor?.name
        roomNumLabel.text = "房间号: \(anchor?.roomid ?? 0)"
        onlineLabel.text = "\(anchor?.focus ?? 0)"
        
    }
    // 添加底部视图
    private func setupBottomView () {
        print(view.bounds)
         // 1. 添加聊天视图
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        // 跳转 xib 的高度和宽度随着屏幕的拉伸而拉伸
        chatToolsView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        // 设置 chatToolsView 代理
        chatToolsView.delegate = self
        view.addSubview(chatToolsView)
        
        // 2. 添加 chatContentView 视图
        chatContentView.frame = CGRect(x: 0, y: view.bounds.height - kChatToolsViewHeight - kChatComtetViewHeight, width: view.bounds.width, height: kChatComtetViewHeight)
        chatContentView.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
        view.addSubview(chatContentView)
        
        // 3. 添加礼物视图
        giftView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kgiftViewHeight)
        giftView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        // 设置 giftView 的代理
        giftView.delegate = self
        view.addSubview(giftView)
        
        // 4.添加更多视图
        moreinfoView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kMoreInfoViewH)
        moreinfoView.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
        view.addSubview(moreinfoView)
        
        // 5.添加分享视图
        shareView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kSocialShareViewH)
        shareView.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
        view.addSubview(shareView)
        
    }
    // 添加蒙版视图
    private func setupBlurView() {
        let blur  = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
        
    }
}

extension XJRoomViewController {
    
    fileprivate func loadAnchorLiveAddress() {
        
        // 1.获取请求的地址
        let URLString = "http://qf.56.com/play/v2/preLoading.ios"
        
        // 2.获取请求的参数
        let parameters : [String : Any] = ["imei" : "36301BB0-8BBA-48B0-91F5-33F1517FA056", "signature" : "f69f4d7d2feb3840f9294179cbcb913f", "roomId" : anchor!.roomid, "userId" : anchor!.uid]
        
        NetworkTools.requestData(.get, URLString: URLString, parameters: parameters) { (result) in
            
            print("--->", result)
             // 1.将result转成字典类型
            guard let resultDict = result as? [String : Any] else {
                return
            }
            // 2.从字典中取出数据
            guard let infoDict = resultDict["message"] as? [String : Any] else {
                return
            }
            print(infoDict)
            // 3.获取请求直播地址的URL
            guard let rURL = infoDict["rUrl"] as? String else {
                return
            }
            
            // 4.请求直播地址
            NetworkTools.requestData(.get, URLString: rURL, parameters: nil, finishedCallback: { (result) in
                
                print("===", result)
                let resultDict = result as? [String : Any]
               let liveURLString =  resultDict?["url"] as? String
                self.displayLiveView(liveURLString)
            })
            
        }
        
    }
    
    private func displayLiveView(_ liveURLString: String?) {
        // 1.获取直播的地址
        guard let liveURLString = liveURLString else {
            return
        }
        
        // 2.使用IJKPlayer播放视频
        let options = IJKFFOptions.byDefault()
        // 1代表是硬解码 0 代表是软解码
        options?.setOptionIntValue(1, forKey: "videotoolbox", of: kIJKFFOptionCategoryPlayer)
        
        ijkPlayer = IJKFFMoviePlayerController(contentURLString: liveURLString, with: options)
        
        // 3. 设置 frame 以及添加到其他 view 中
        if anchor?.push == 1 {
            ijkPlayer?.view.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: bgImageView.bounds.width, height: bgImageView.bounds.width * 3 / 4))
        }else {
            ijkPlayer?.view.frame = bgImageView.bounds
        }
        
        bgImageView.addSubview((ijkPlayer?.view)!)
        ijkPlayer?.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        // 4. 开始播放
        ijkPlayer?.prepareToPlay()
        
    }
}

// MARK: 监听键盘的弹出
extension XJRoomViewController {
    @objc fileprivate func keyboardWillChangeFrame(_ note: Notification) {
        print("监听键盘弹出")
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight
        
        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
            // 判断键盘是不是退出
            let endY = inputViewY == (kScreenH - kChatToolsViewHeight) ? kScreenH : inputViewY
            self.chatToolsView.frame.origin.y = endY
            
            // 设置 chatContentView 的高度
            let contentEndY = inputViewY == (kScreenH - kChatToolsViewHeight) ? (kScreenH - kChatComtetViewHeight - 44) : endY - kChatComtetViewHeight
            self.chatContentView.frame.origin.y = contentEndY
            
        })

    }
}

// MARK: --  监听事件点击
extension XJRoomViewController {
    
    // 推出键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25) {
            self.chatToolsView.inputTextField.resignFirstResponder()
            
            self.giftView.frame.origin.y = kScreenH
            self.moreinfoView.frame.origin.y = kScreenH
            self.shareView.frame.origin.y = kScreenH
        }
    }
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("点击了聊天")
            // 通过iputTextField 来调出键盘
            chatToolsView.inputTextField.becomeFirstResponder()
        case 1:
            print("点击了分享")
            UIView.animate(withDuration: 0.25, animations: { 
                self.shareView.frame.origin.y = kScreenH - kSocialShareViewH
            })
            shareView.showShareView()
        case 2:
            print("点击了礼物")
            UIView.animate(withDuration: 0.25, animations: {
                self.giftView.frame.origin.y = kScreenH - kgiftViewHeight
            })
        case 3:
            print("点击了更多")
            UIView.animate(withDuration: 0.25, animations: { 
                self.moreinfoView.frame.origin.y = kScreenH - kMoreInfoViewH
            })
        case 4:
            print("点击了粒子")

            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            
            sender.isSelected ? startEmittering(point) : stopEmittering()
            
        default:
            fatalError("未处理按钮")
        }
    }

    @IBAction func focusBtnClick(_ sender: UIButton) {
        // 1.改变按钮的状态
        sender.isSelected = !sender.isSelected
        // 2.改变数据库的内容
    }


}


// MARK: - XJChatToolsViewDelegate
extension XJRoomViewController : XJChatToolsViewDelegate,XJGiftListViewDelegate {
    
    func chatToolsView(chatToolsView: XJChatToolsView, message: String) {
        // 将消息发送给服务器的时候, emoticon 发送给服务器的是字符串,不是发送的图片,服务器在接受到发送的消息后,然后在将消息转发给房间的其他用户,别的用户在拿到服务器转发的内容后,在将字符串转化成图片,显示到界面上
        print(message)
        // 将消息发送给服务器
        socket.sendTextMsg(message: message)
    }
    
    func giftListView(giftListView: XJGiftListView, giftModel: XJGiftModel) {
        print(giftModel.subject)
        // 将消息发送给服务器
        socket.sendGiftMsg(giftName: giftModel.subject, giftURL: giftModel.img2, giftCount: 1)
    }
    
}


// MARK:- 给服务器发送即时消息
extension XJRoomViewController {
    
    // 添加心跳包
    fileprivate func addHeartBeatTimer() {
        // 1.创建定时器
        heartBeatTimer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
        // 2.将定时器添加到事件循环中
         RunLoop.main.add(heartBeatTimer!, forMode: .commonModes)
    }
    
    @objc private func sendHeartBeat() {
        socket.sendHeartBeat()
    }
}

extension XJRoomViewController : XJSocketDelegate {
    
    // 加入房间
    func socket(_ socket: XJSocket, joinRoom user: UserInfo) {
//        chatContentView.insertMessage("\(user.name) 进入房间")
        
        /**
         let joinRoomStr = "\(user.name) 进入房间"
        
         let auttributedMutabkeStr = NSMutableAttributedString(string: joinRoomStr)
         
         // 设置富文本的属性
         auttributedMutabkeStr.addAttributes([NSForegroundColorAttributeName : UIColor.orange], range: NSRange(location: 0, length: user.name.characters.count))
         
         //在文字后面添加一个小图片
         let attachment = NSTextAttachment()
         // 设置图片的大小跟字体的高度一样
         let font = UIFont.systemFont(ofSize: 15)
         attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
         attachment.image = UIImage(named: "room_btn_gift")
         let imageAttrStr = NSAttributedString(attachment: attachment)
         // 将添加的图片拼接到 文本后面
         auttributedMutabkeStr.append(imageAttrStr)

         */
      let auttributedMutabkeStr =  XJAttributedStringGenerator.generateJoinOrLeaveRoom(user.name, true)
        // 将富文本发送给服务器
        chatContentView.insertMessage(auttributedMutabkeStr)

    }
    
    // 离开房间
    func socket(_ socket: XJSocket, leaveRoom user: UserInfo) {
//        chatContentView.insertMessage("\(user.name) 离开房间")
        
        /**
         let attributStr = NSAttributedString(string: "\(user.name) 离开房间")
         
         let attributMutableStr = NSMutableAttributedString(attributedString: attributStr)
         attributMutableStr.addAttributes([NSForegroundColorAttributeName : UIColor.orange], range: NSRange(location: 0, length: user.name.characters.count))
         */
     
        let leaveRoomMAttrStr = XJAttributedStringGenerator.generateJoinOrLeaveRoom(user.name, false)
        chatContentView.insertMessage(leaveRoomMAttrStr)
        
    }
    
    // 发送聊天信息
    func socket(_ socket: XJSocket, chatMsg: ChatMessage) {
//        chatContentView.insertMessage("\(chatMsg.user.name): \(chatMsg.text)")
        /**
         // 1. 获取整个字符串
         let chatMessage = "\(chatMsg.user.name): \(chatMsg.text)"
         // 2. 根据整个字符串创建NSMutableAttributedString
         let chatMsgMAttr = NSMutableAttributedString(string: chatMessage)
         
         // 3. 需改名称的颜色
         chatMsgMAttr.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: chatMsg.user.name.characters.count))
         
         // 4.将所有表情匹配出来, 并且换成对应的图片进行展示
         // 4.1.创建正则表达式匹配表情 我是主播[哈哈], [嘻嘻][嘻嘻] [123444534545235]
         // 在正则表达式中 . 表示任意字符, *表示任意多个  .* 表示任意多个任意字符 ?表示只要有一个符合规则的东西,就立刻匹配出来
         // 4.1.1 创建匹配规则
         let pattern = "\\[.*?\\]"
         // 4.1.2 创建正则表达式
         guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return  }
         // 4.1.3 开始拼配
         /**
         1.in 里面传 在哪个字符串中进行匹配
         2.length: 里面传入的是在哪个字符串中 要匹配的范围(即在字符串中哪些字符串需要匹配)
         3.这个方法的返回值是一个数组, 然后遍历这个数组取出结果
         */
         let results = regex.matches(in: chatMessage, options: [], range: NSRange(location: 0, length: chatMessage.characters.count))
         
         // 4.2 获取表情的结果 反向遍历字符串,从后往前遍历
         for i in (0..<results.count).reversed() {
         // 匹配结果的时候从前往后取
         // 4.3 获取结果
         let result = results[i]
         // 获取当前表情的图片的名称
         let emoticonName = (chatMessage as NSString).substring(with: result.range)
         // 4.4 根据取到的字符串的结果去查找对应的图片
         guard let image = UIImage(named: emoticonName) else {
         continue
         }
         // 4.5 根据图片创建 NSTextAttachment
         let attachment = NSTextAttachment()
         attachment.image = image
         let font = UIFont.systemFont(ofSize: 15)
         attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
         
         
         let attributedStr = NSAttributedString(attachment: attachment)
         //4.6 将imageAttrStr替换到之前文本的位置
         chatMsgMAttr.replaceCharacters(in: result.range, with: attributedStr)
         }         
         */
    
        let chatMsgMAttr = XJAttributedStringGenerator.generateTextMessage(chatMsg.user.name, chatMsg.text)
        // 5. 将文本的属性字符串插入到内容 View 中
        chatContentView.insertMessage(chatMsgMAttr)
        
    }
    
    // 发送礼物信息
    func socket(_ socket: XJSocket, giftMsg: GiftMessage) {
//        chatContentView.insertMessage("\(giftMsg.user.name)赠送 \(giftMsg.giftname) \(giftMsg.giftUrl)")
        /**
        // 1. 获取赠送礼物的字符串
        let giftMsgStr = "\(giftMsg.user.name)赠送 \(giftMsg.giftname)"
        // 2. 根据字符串创建一个 NSMutableAttributeString
        let sendGiftMAttrMsg = NSMutableAttributedString(string: giftMsgStr)
        // 3. 修改用户的名称
        sendGiftMAttrMsg.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: 0, length: giftMsg.user.name.characters.count))
        
        // 4. 修改礼物的名称
        let range = (giftMsgStr as NSString).range(of: giftMsg.giftname)
        sendGiftMAttrMsg.addAttributes([NSForegroundColorAttributeName: UIColor.red], range: range)
        
        // 5.在最后拼接上礼物的图片
        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: giftMsg.giftUrl) else {
            chatContentView.insertMessage(sendGiftMAttrMsg)
            return
        }
        
        let attacment = NSTextAttachment()
        attacment.image = image
        let font = UIFont.systemFont(ofSize: 15)
        attacment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
        let imageAttrStr = NSAttributedString(attachment: attacment)
        
        // 6. 将imageAttrStr拼接到最后
        sendGiftMAttrMsg.append(imageAttrStr)
        */
        let sendGiftMAttrMsg = XJAttributedStringGenerator.generateGiftMessge(giftMsg.user.name, giftMsg.giftname, giftMsg.giftUrl)
        // 7. 将内容显示到chatContentView 上面
        chatContentView.insertMessage(sendGiftMAttrMsg)
        
        // 8. 从服务器取出礼物模型,然后以动画的形式展示到用户面前,并将礼物送出
        let giftMsgModel = XJGiftMessageModel(senderName: giftMsg.user.name, senderURL: "icon2", giftName: giftMsg.giftname, giftURL: giftMsg.giftUrl)
        giftContainerView.showGiftModelView(giftMsgModel)
        
        
    }
}
