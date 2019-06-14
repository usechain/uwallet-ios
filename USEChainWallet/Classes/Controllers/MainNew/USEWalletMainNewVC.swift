//
//  USEWalletMainViewController.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/2/28.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit
import SnapKit


class USEWalletMainNewVC: UIViewController {

    @objc private func clickedBtn(btn: UIButton) {
        if btn.tag == 1 {
            self.navigationController?.pushViewController(USECreateWalletVC(), animated: true)
        } else {
            self.navigationController?.pushViewController(USEImportWalletVC(), animated: true)
        }
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 13/255, green: 61/255, blue: 115/255, alpha: 1.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let target = self.navigationController?.interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer.init(target: target, action: nil)
        self.view.addGestureRecognizer(pan)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    // MARK: -Lazyloadkit
    fileprivate lazy var backImageView: UIImageView = {
        let temp = UIImageView()
        temp.image = UIImage.init(named: "bg1")
        return temp
    }()
    fileprivate lazy var titleLabelTop: UILabel = UILabel(title: NSLocalizedString("Create your first", comment: ""), fontSize: 30, color: UIColor(red: 60/255, green: 221/255, blue: 235/255, alpha: 1.0), redundance: 0)
    fileprivate lazy var titleLabelBottom: UILabel = UILabel(title: NSLocalizedString("Decentralized Wallet", comment: ""), fontSize: 30, color: UIColor(red: 60/255, green: 221/255, blue: 235/255, alpha: 1.0), redundance: 0)
    fileprivate lazy var createBtn: UIButton = {
        let btn = UIButton(title: "创建钱包", fontSize: 20, color: UIColor(red: 45/255, green: 255/255, blue: 254/255, alpha: 1.0), imageName: nil, backColor: nil)
        btn.layer.cornerRadius = 30
        btn.layer.borderColor = UIColor(red: 45/255, green: 255/255, blue: 254/255, alpha: 1.0).cgColor
        btn.layer.borderWidth = 1
        btn.tag = 1
        btn.addTarget(self, action: #selector(USEWalletMainNewVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    fileprivate lazy var importWalletBtn: UIButton = {
        let btn = UIButton(title: "导入钱包", fontSize: 20, color: UIColor(red: 45/255, green: 255/255, blue: 254/255, alpha: 1.0), imageName: nil, backColor: nil)
        btn.layer.borderColor = UIColor(red: 45/255, green: 255/255, blue: 254/255, alpha: 1.0).cgColor
        btn.layer.borderWidth = 1
        btn.tag = 2
        btn.addTarget(self, action: #selector(USEWalletMainNewVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        btn.layer.cornerRadius = 30
        return btn
    }()
}

extension USEWalletMainNewVC {
    fileprivate func setupUI() {
        self.view.addSubview(titleLabelTop)
        self.view.addSubview(titleLabelBottom)
        self.view.addSubview(createBtn)
        self.view.addSubview(importWalletBtn)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        titleLabelTop.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(200)
            make.centerX.equalTo(self.view)
        }
        titleLabelBottom.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabelTop.snp.bottom).offset(20)
            make.centerX.equalTo(titleLabelTop)
        }
        createBtn.snp.makeConstraints { (make) in
           make.bottom.equalTo(importWalletBtn.snp.top).offset(-30)
            make.centerX.equalTo(self.view)
            make.height.equalTo(60)
            make.width.equalTo(UIScreen.main.bounds.size.width * 0.7)
        }
        importWalletBtn.snp.makeConstraints { (make) in
           make.bottom.equalTo(self.view).offset(-100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(60)
            make.width.equalTo(UIScreen.main.bounds.size.width * 0.7)
        }
    }
}
