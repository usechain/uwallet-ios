//
//  USECreateWalletVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/11.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USECreateWalletVC: USEWalletBaseVC {
    
    @objc private func clickedBtn(btn: UIButton) {
        if btn.tag == 1 {
            if (self.passcode.text == self.repeatPasscode.text) && self.passcode.text != "" &&  self.walletName.text != "" {
                UserDefaults.standard.setValue(self.passcode.text, forKey: "USEUserWalletPasscode")
                UserDefaults.standard.setValue(self.walletName.text, forKey: "USEUserWalletName")

                self.navigationController?.pushViewController(USEBackupMnemonicVC(), animated: true)
            } else if self.walletName.text == "" {
                showAlterView("钱包名称不能为空", mySelf: self)
            } else if self.passcode.text == "" {
                showAlterView("钱包密码不能为空", mySelf: self)
            } else {
                showAlterView("重复钱包密码不一致", mySelf: self)
            }
        } else {
            // 导入钱包
            self.navigationController?.pushViewController(USEImportWalletVC(), animated: true)
        }
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "创建钱包"
        self.walletName.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: -layloadKit
    fileprivate lazy var topWarninglabel: UILabel = UILabel(title: "•密码用于保护私钥和交易授权，强度非常重要", fontSize: 12, color: UIColor(red: 246/255, green: 11/255, blue: 11/255, alpha: 1.0), redundance: 0)
    fileprivate lazy var bottomWarningLabel: UILabel = UILabel(title: "•我们不存储密码，也无法帮您找回，请牢记您的密码", fontSize: 12, color: UIColor(red: 246/255, green: 11/255, blue: 11/255, alpha: 1.0), redundance: 0)
    fileprivate lazy var topGrayView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor(hexString: "f2f2f2")
        return tempView
    }()
    fileprivate lazy var walletName: TXLimitedTextField = {
        let tempTF = TXLimitedTextField()
        tempTF.placeholder = "钱包名称"
        tempTF.font = UIFont.systemFont(ofSize: CGFloat(18))
        return tempTF
    }()
    fileprivate lazy var walletNameLine: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor(hexString: "bfbfbf")
        //tempView.alpha = 0.59
        return tempView
    }()
    fileprivate lazy var passcode: TXLimitedTextField = {
        let tempTF = TXLimitedTextField()
        tempTF.limitedType = TXLimitedTextFieldType.custom
        tempTF.limitedRegExs = [kTXLimitedTextFieldEnglishAndNumberRegex]
        tempTF.placeholder = "请输入密码"
        tempTF.isSecureTextEntry = true
        tempTF.font = UIFont.systemFont(ofSize: CGFloat(18))
        return tempTF
    }()
    fileprivate lazy var passcodeLine: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor(hexString: "bfbfbf")
        return tempView
    }()
    fileprivate lazy var repeatPasscode: TXLimitedTextField = {
        let tempTF = TXLimitedTextField()
        tempTF.limitedType = TXLimitedTextFieldType.custom
        tempTF.limitedRegExs = [kTXLimitedTextFieldEnglishAndNumberRegex]
        tempTF.isSecureTextEntry = true
        tempTF.placeholder = "请重复输入密码"
        tempTF.font = UIFont.systemFont(ofSize: CGFloat(18))
        return tempTF
    }()
    fileprivate lazy var repeatPasscodeLine: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor(hexString: "bfbfbf")
        return tempView
    }()
    
    fileprivate lazy var createWalltBtn: UIButton = {
        let tempBtn = UIButton(title: "创建钱包", fontSize: 16, color: UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0), imageName: nil, backColor: UIColor(red: 50/255, green: 137/255, blue: 252/255, alpha: 1.0))
        tempBtn.layer.cornerRadius = 20
        tempBtn.addTarget(self, action: #selector(USECreateWalletVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        tempBtn.tag = 1
        return tempBtn
    }()
    fileprivate lazy var importWalletBtn: UIButton = {
        let tempBtn = UIButton(title: "开始导入", fontSize: 16, color: UIColor(hexString: "3289fc") ?? UIColor.black, imageName: nil, backColor: nil)
        tempBtn.addTarget(self, action: #selector(USECreateWalletVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        tempBtn.tag = 2
        return tempBtn
    }()
}

extension USECreateWalletVC {
    fileprivate func setupUI() {
        // addsubviews
        self.view.addSubview(topGrayView)
        topGrayView.addSubview(topWarninglabel)
        topGrayView.addSubview(bottomWarningLabel)
        self.view.addSubview(walletName)
        self.view.addSubview(walletNameLine)
        self.view.addSubview(passcode)
        self.view.addSubview(passcodeLine)
        self.view.addSubview(repeatPasscode)
        self.view.addSubview(repeatPasscodeLine)
        self.view.addSubview(createWalltBtn)
        self.view.addSubview(importWalletBtn)
        
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        // layout
        topGrayView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(89)
        }
        topWarninglabel.snp.makeConstraints { (make) in
            make.top.equalTo(topGrayView).offset(26)
            make.left.equalTo(topGrayView).offset(15)
        }
        bottomWarningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topWarninglabel.snp.bottom).offset(11)
            make.left.equalTo(topWarninglabel)
        }
        walletName.snp.makeConstraints { (make) in
            make.top.equalTo(topGrayView.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
        }
        walletNameLine.snp.makeConstraints { (make) in
            make.top.equalTo(walletName.snp.bottom).offset(1)
            make.left.equalTo(walletName)
            make.height.equalTo(1)
            make.right.equalTo(self.view).offset(-15)
        }
        passcode.snp.makeConstraints { (make) in
            make.top.equalTo(walletNameLine.snp.bottom).offset(37)
            make.left.equalTo(walletNameLine)
                        make.right.equalTo(self.view).offset(-15)
        }
        passcodeLine.snp.makeConstraints { (make) in
            make.top.equalTo(passcode.snp.bottom).offset(1)
            make.left.equalTo(passcode)
            make.height.equalTo(1)
            make.right.equalTo(self.view).offset(-15)
        }
        repeatPasscode.snp.makeConstraints { (make) in
            make.top.equalTo(passcodeLine.snp.bottom).offset(37)
            make.left.equalTo(passcodeLine)
                        make.right.equalTo(self.view).offset(-15)
        }
        repeatPasscodeLine.snp.makeConstraints { (make) in
            make.top.equalTo(repeatPasscode.snp.bottom).offset(1)
            make.left.equalTo(repeatPasscode)
            make.height.equalTo(1)
            make.right.equalTo(self.view).offset(-15)
        }
        importWalletBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-30)
        }
        createWalltBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(importWalletBtn.snp.top).offset(-15)
            make.height.equalTo(43)
            make.width.equalTo(UIScreen.main.bounds.size.width * 0.75)
            make.centerX.equalTo(self.view)
        }
    }
}
