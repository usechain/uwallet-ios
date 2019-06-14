//
//  USEAVCaptureTools.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/5/28.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit
import AVKit
import QRCodeReader

class USEAVCaptureTools: NSObject {
    
    @objc class func hasAVCaptureAuthorization() -> Bool {
        if (AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .notDetermined || AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .denied || AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .restricted) {
            return false
        } else {
            return true
        }
    }
    
    @objc class func requestForAVCaptureAuthorization(resource: @escaping (_ state:Any?) ->()) {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (statusFirst) in
                if statusFirst {
                    resource(true)
                } else {
                    resource(false)
                }
            })
     }
    
    @objc class func checkScanPermissions(mySelf: AnyObject) -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            switch error.code {
            case -11852:
                alert = UIAlertController(
                    title: "啊哦！",
                    message: "请开通访问相机的权限",
                    preferredStyle: .alert)
                
                alert.addAction(
                    UIAlertAction(
                        title: "设置",
                        style: .default,
                        handler: { (_) in
                            DispatchQueue.main.async {
                                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.openURL(settingsURL)
                                }
                            }
                    }))
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "啊哦！", message: "当前设备不支持", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好的", style: .cancel, handler: nil))
            }
            mySelf.present(alert, animated: true, completion: nil)
            return false
        }
        
    }
    
}
