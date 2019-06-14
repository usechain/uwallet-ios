//
//  USEInfoVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/4/1.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEKYCInfoVC: USEWalletBaseVC {

    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
        self.navigationController?.pushViewController(USEKYCCAChooseVC(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "KYC提示"
        self.view.backgroundColor = UIColor.white
    }
    
    fileprivate lazy var topLabel: UILabel = UILabel(title: "★ 您当前还没有主地址，需要先通过认证升级获得主地址", fontSize: 16, color: UIColor.black, redundance: 60)
    fileprivate lazy var middleLabel: UILabel = UILabel(title: "★ 主地址将获得自由交易权限，并可注册矿工，参与委员会投票、选举", fontSize: 16, color: UIColor.black, redundance: 60)
    fileprivate lazy var bottomLabel: UILabel = UILabel(title: "★ 特别提示: 认证升级过程可能会产生交易费用，需要使用USE支付", fontSize: 16, color: UIColor.black, redundance: 60)
    fileprivate lazy var nextBtn: UIButton = {
        let temp = UIButton(title: "下一步", fontSize: 20, color: UIColor.white, imageName: nil, backColor: UIColor(red: 40/255, green: 113/255, blue: 251/255, alpha: 1.0))
        temp.addTarget(self, action: #selector(USEKYCInfoVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        temp.layer.cornerRadius = 20
        return temp
    }()
    
}

extension USEKYCInfoVC {
    
    fileprivate func setupUI() {
        self.view.addSubview(topLabel)
        self.view.addSubview(middleLabel)
        self.view.addSubview(bottomLabel)
        self.view.addSubview(nextBtn)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(30)
        }
        middleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(30)
            make.left.equalTo(topLabel)
        }
        bottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(middleLabel.snp.bottom).offset(30)
            make.left.equalTo(middleLabel)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(bottomLabel.snp.bottom).offset(50)
            make.width.equalTo(200)
        }
    }
    
}
