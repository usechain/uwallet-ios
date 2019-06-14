//
//  Protocal.swift
//  Dazui
//
//  Created by wakaka on 2017/8/22.
//  Copyright © 2017年 you. All rights reserved.
//

import Foundation
//import MBProgressHUD

/// 遵守此协议可以实现倒计时功能
protocol CountDownable {
    var timer: Timer! { set get }
    var totalTimeInterval: TimeInterval { set get }
    var currentTimeInterval: TimeInterval { set get }
    
    func startTimer()
    func upDateTime()
}

/// 此协议实现弹窗显示error
@objc protocol HUDPresenter: class {

    @objc optional func showError(_ errorInfo: String)
    @objc optional func showProgress(progress: Float)
}

/// 此协议实现alert控制器
@objc protocol AlertPresenter {
    //系统弹框
    @objc optional func showAlertWithStr(_ str: String)
    @objc optional func showAlertWithBtnTitle(_ str: String, _ btnTitle: String)
    @objc optional func showAlertWithCancel(_ str: String, _ btnTitle: String)
    @objc optional func showAlertWithHandler(_ str: String, _ handler: @escaping (UIAlertAction)->())
    @objc optional func showAlert(_ str: String, _ btnTitle: String, _ isCancel: Bool , _ handler:  ((UIAlertAction)->())?)
    // 相册选择sheet
    @objc optional func showAlertChooseImage(allowsEdit: Bool)
}

//此协议实现根据网络请求得到的状态码判断此时token是否有效的功能，如失效，则present出登录控制器
protocol TokenValidator {
    // 补充说明：如果返回的状态码是22000，说明token失效，此时应该重新登录（所有接口）
    func validateToken(statusCode: Int, _ message: String) -> Bool
}

/// 此协议可以完成
protocol KeyBoardAdjust {
    func adjustKeyboard(view: UIView)
}
