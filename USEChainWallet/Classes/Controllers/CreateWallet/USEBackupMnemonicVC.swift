//
//  USEBackupMnemonicVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/11.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit
import TangramKit
class USEBackupMnemonicVC: USEWalletBaseVC {

    @objc private func clickedBtn(btn: UIButton) {
            // 下一步
            self.navigationController?.pushViewController(USEConfrimMnemonicNewVC(), animated: true)
    }
    
    override func loadView() {
        super.loadView()
        seupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "备份助记词"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    // MARK: -lazyload kit
    fileprivate lazy var topBackView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor(hexString: "f2f2f2")
        return tempView
    }()
    fileprivate lazy var topWarningPointLabel: UILabel =  UILabel(title: "•", fontSize: 16, color: UIColor(hexString: "f60b0b") ?? UIColor.red, redundance: 0)
    fileprivate lazy var topWarningLabel: UILabel = UILabel(title: "强烈建议您将助记词抄写在纸上，并保存在只有您知道的安全的地方，任何人得到助记词都可以窃取您的数字资产", fontSize: 12, color: UIColor(hexString: "f60b0b") ?? UIColor.black, redundance: 2)
    fileprivate lazy var bottomWarningPointLabel: UILabel =  UILabel(title: "•", fontSize: 16, color: UIColor(hexString: "f60b0b") ?? UIColor.red, redundance: 0)
    fileprivate lazy var bottomWarningLabel: UILabel = UILabel(title: "我们不存储密码，也无法帮您找回，请牢记您的密码", fontSize: 12, color:UIColor(hexString: "f60b0b") ?? UIColor.black, redundance: 2)
    // 这块有一个12宫格 需要引入
    fileprivate lazy var mnemonicView: TGFlowLayout = {
        let account = UseEthersManager.createAccount()
        UserDefaults.standard.setValue(account?.mnemonicPhrase, forKey: "USEUserWalletMnemonic")
        let mnemonicArray = account?.mnemonicPhrase!.components(separatedBy: " ")
        let S = TGFlowLayout(.vert,arrangedCount:4)
        S.tg_height.equal(.wrap)
        //S.tg_width.equal(300)
        S.tg_padding = UIEdgeInsets(top: 2,left: 2,bottom: 2,right: 2)
        //S.tg_gravity = TGGravity.horz.fill
        S.tg_space = 2

        for i in 0 ..< 12
        {
            let mnemonicLabel = UILabel(title: mnemonicArray?[i] ?? "", fontSize: 15, color: UIColor(hexString: "333333") ?? UIColor.black, redundance: 0)
            let backView = UIView()
            backView.tg_height.equal((UIScreen.main.bounds.size.width - 30) / 7)
            backView.tg_width.equal((UIScreen.main.bounds.size.width - 30) / 4)
            S.addSubview(backView)
            backView.addSubview(mnemonicLabel)
            mnemonicLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(backView)
                make.centerX.equalTo(backView)
            }
        }
        S.backgroundColor = UIColor(hexString: "f2f2f2")
        S.layer.cornerRadius = 5
        return S
    }()
    
    fileprivate lazy var nextBtn: UIButton = {
        let tempBtn = UIButton(title: "下一步", fontSize: 16, color: UIColor.white, imageName: nil, backColor: UIColor(hexString: "3289fc") ?? UIColor.black)
        tempBtn.addTarget(self, action: #selector(USEBackupMnemonicVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        tempBtn.layer.cornerRadius = 25
        return tempBtn
    }()
}

extension USEBackupMnemonicVC {
    fileprivate func seupUI() {
        // addsubviews
        self.view.addSubview(topBackView)
        topBackView.addSubview(topWarningPointLabel)
        topBackView.addSubview(topWarningLabel)
        topBackView.addSubview(bottomWarningPointLabel)
        topBackView.addSubview(bottomWarningLabel)
        self.view.addSubview(mnemonicView)
        self.view.addSubview(nextBtn)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // layout
        topBackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(100)
        }
        topWarningPointLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topBackView.snp.top).offset(23)
            make.left.equalTo(topBackView).offset(15)
        }
        topWarningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topBackView.snp.top).offset(26)
            make.left.equalTo(topWarningPointLabel).offset(10)
            make.right.equalTo(topBackView).offset(-10)
        }
        bottomWarningPointLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topWarningPointLabel.snp.bottom).offset(19)
            make.left.equalTo(topBackView).offset(15)
        }
        bottomWarningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topWarningLabel.snp.bottom).offset(11)
            make.left.equalTo(bottomWarningPointLabel).offset(10)
            make.right.equalTo(topBackView).offset(-10)
        }
        mnemonicView.snp.makeConstraints { (make) in
           // make.centerX.equalTo(self.view)
            make.top.equalTo(topBackView.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-100)
        }
    }
}
