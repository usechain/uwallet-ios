//
//  USEExportKeystoreVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/22.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEExportKeystoreVC: USEWalletBaseVC {
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = keystoreLabel.text
        showAlterView("复制成功", mySelf: self)
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showHUD(withText: "努力导出中...")
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "导出Keystore"
        let walletStore = walletInfo[1]
        if Account.isValidMnemonicPhrase(walletStore) {
            let account = UseEthersManager(mnemonicPhrase: walletStore, slot: 0)
            let passcode = (UserDefaults.standard.value(forKey: walletStore) as! Array<String>).last
            account?.encryptSecretStorageJSON(passcode, callback: { (result) in
                self.keystoreLabel.text = result
                self.hideHUD()
            })
        } else {
            let account = UseEthersManager(privateKey: walletStore.hexToBytes)
            let passcode = (UserDefaults.standard.value(forKey: walletStore) as! Array<String>).last
            account?.encryptSecretStorageJSON(passcode, callback: { (result) in
                self.keystoreLabel.text = result
                self.hideHUD()
            })
        }
    }
    fileprivate lazy var walletInfo: Array = { () -> [String] in
        let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        return useCurrentAccountArray ?? []
    }()
    fileprivate lazy var topTitleLabel: UILabel = UILabel(title: "★ 离线保存", fontSize: 18, color: UIColor.red, redundance: 0)
    fileprivate lazy var topLabel: UILabel = UILabel(title: "切勿保存至邮箱、记事本、网盘、聊天工具等、非常危险。", fontSize: 16, color: UIColor.black, redundance: 40)
    fileprivate lazy var middleTitleLabel: UILabel = UILabel(title: "★ 请勿使用网络传输", fontSize: 18, color: UIColor.red, redundance: 20)
    fileprivate lazy var middleLaebl: UILabel = UILabel(title: "请勿使用网络工具传输，一旦被黑客获取将造成不可挽回的资产损失", fontSize: 16, color: UIColor.black, redundance: 40)
    fileprivate lazy var bottomTitlLabel: UILabel = UILabel(title: "★ 在安全环境下使用", fontSize: 18, color: UIColor.red, redundance: 0)
    fileprivate lazy var bottomLabel: UILabel = UILabel(title: "请确保四周无人及摄像头的情况下使用，私钥一旦被他人获取，将造成不可挽回的资产损失", fontSize: 16, color: UIColor.black, redundance: 40)
    fileprivate lazy var sqrView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.white
        temp.layer.borderColor = UIColor.gray.cgColor
        temp.layer.masksToBounds = true
        temp.layer.borderWidth = 1
        temp.isUserInteractionEnabled = true
        return temp
    }()
    fileprivate lazy var keystoreLabel: UILabel = UILabel(title: "", fontSize: 14, color: UIColor.black, redundance: 100)
    fileprivate lazy var copyBtn: UIButton = {
        let temp = UIButton(title: "复制", fontSize: 18, color: UIColor.white, imageName: nil, backColor: UIColor(red: 55/255, green: 140/255, blue: 248/255, alpha: 1.0))
        temp.addTarget(self, action: #selector(USEExportKeystoreVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        temp.layer.cornerRadius = 10
        return temp
    }()
}

extension USEExportKeystoreVC {
    fileprivate func setupUI() {
        self.view.addSubview(topTitleLabel)
        self.view.addSubview(topLabel)
        self.view.addSubview(middleTitleLabel)
        self.view.addSubview(middleLaebl)
        self.view.addSubview(bottomTitlLabel)
        self.view.addSubview(bottomLabel)
        
        self.view.addSubview(sqrView)
        sqrView.addSubview(keystoreLabel)
        self.view.addSubview(copyBtn)
        
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        topTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(20)
        }
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(topTitleLabel.snp.left).offset(10)
        }
        middleTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(10)
            make.left.equalTo(topTitleLabel)
        }
        middleLaebl.snp.makeConstraints { (make) in
            make.top.equalTo(middleTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(topLabel)
        }
        bottomTitlLabel.snp.makeConstraints { (make) in
            make.top.equalTo(middleLaebl.snp.bottom).offset(10)
            make.left.equalTo(middleTitleLabel)
        }
        bottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomTitlLabel.snp.bottom).offset(5)
            make.left.equalTo(middleLaebl)
        }

        sqrView.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self.view)
            make.height.equalTo(200)
            make.width.equalTo(UIScreen.main.bounds.size.width * 0.8)
        }
        keystoreLabel.snp.makeConstraints { (make) in
            make.center.equalTo(sqrView)
            make.top.equalTo(sqrView.snp.top).offset(10)
            make.bottom.equalTo(sqrView.snp.bottom).offset(-10)
        }
        copyBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(sqrView.snp.bottom).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
    }
}
