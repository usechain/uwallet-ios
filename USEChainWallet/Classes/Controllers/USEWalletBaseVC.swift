//
//  DZWalletBaseVC.swift
//  Dazui
//
//  Created by Jacob on 2017/3/10.
//  Copyright © 2017年 you. All rights reserved.
//

import UIKit

class USEWalletBaseVC: UIViewController {

    @objc func clickBtn() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 11/255, green: 43/255, blue: 97/255, alpha: 1.0)
        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
        self.view.backgroundColor = UIColor.white
        cusBackBtn()
    }
}

extension USEWalletBaseVC: UIGestureRecognizerDelegate {
}

extension USEWalletBaseVC {
    //自定义左侧返回按钮
    fileprivate func cusBackBtn() {
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        backBtn.setImage(UIImage.init(named: "Left"), for: UIControl.State.normal)
        backBtn.setImage(UIImage.init(named: "Left"), for: UIControl.State.highlighted)
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        let backItem = UIBarButtonItem.init(customView: backBtn)
        backBtn.addTarget(self, action: #selector(USEWalletBaseVC.clickBtn), for: UIControl.Event.touchUpInside)
        self.navigationItem.leftBarButtonItem = backItem
    }
}
