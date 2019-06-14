//
//  USEMineHelpUsVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/30.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEMineHelpUsVC: USEWalletBaseVC {

    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "帮助中心"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
    }
    fileprivate lazy var topTitleLabel: UILabel = UILabel(title: "1.如何创建钱包?", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var topLabel: UILabel = UILabel(title: "您可以创建，亦可以导入钱包。", fontSize: 16, color: UIColor.gray, redundance: 20)
    fileprivate lazy var bottomTitleLabel: UILabel = UILabel(title: "2.什么是匿名地址?", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var bottomLabel: UILabel = UILabel(title: "其他人即便获取到您的地址信息，仍无法获取您的身份信息及操作行为。", fontSize: 16, color: UIColor.gray, redundance: 20)
    
}

extension USEMineHelpUsVC {
    
    fileprivate func setupUI() {
        self.view.addSubview(topTitleLabel)
        self.view.addSubview(topLabel)
        self.view.addSubview(bottomTitleLabel)
        self.view.addSubview(bottomLabel)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        topTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(40)
            make.left.equalTo(self.view).offset(15)
        }
        topLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topTitleLabel)
            make.top.equalTo(topTitleLabel.snp.bottom).offset(15)
        }
        bottomTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topLabel)
            make.top.equalTo(topLabel.snp.bottom).offset(30)
        }
        bottomLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bottomTitleLabel)
            make.top.equalTo(bottomTitleLabel.snp.bottom).offset(15)
        }
    }
    
}
