//
//  USEKYCRegisteToChain.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/21.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEKYCRegisteToChainVC: USEWalletBaseVC {
    
    override func loadView() {
        super.loadView()
        let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let currentAddress = "0x" + (accountInfo?.last)!
        UseChainNetTools.getAccountStatus(address:  currentAddress as NSString) { (result, error) in
            let chainStateHex = (result as! [String: Any])["result"] as! String
            // 16进制转10进制
            if (chainStateHex.hexToUInt256?.value == 3 || chainStateHex.hexToUInt256?.value == 11) {
                self.chainStateLabel.text = "认证成功"
                self.chainStateLabel.isHidden = false
                self.mentionLabel.isHidden = true
                self.nextBtn.isHidden = true
            } else if (chainStateHex.hexToUInt256?.value == 0 || chainStateHex.hexToUInt256?.value == 8) {
                // 未注册
                self.chainStateLabel.text = "委员会还未开始认证"
                self.chainStateLabel.isHidden = false
                self.mentionLabel.isHidden = true
                self.nextBtn.isHidden = true
            }  else if (chainStateHex.hexToUInt256?.value == 1 || chainStateHex.hexToUInt256?.value == 9) {
                // 委员会还未认证
                self.chainStateLabel.text = "委员会还未开始认证"
                self.chainStateLabel.isHidden = false
                self.mentionLabel.isHidden = true
                self.nextBtn.isHidden = true
            } else if (chainStateHex.hexToUInt256?.value == 2 || chainStateHex.hexToUInt256?.value == 10) {
                // 认证中
                self.chainStateLabel.text = "认证中"
                self.chainStateLabel.isHidden = false
                self.mentionLabel.isHidden = true
                self.nextBtn.isHidden = true
            } else {
                // 认证失败
                self.chainStateLabel.isHidden = true
                self.mentionLabel.isHidden = false
                self.nextBtn.isHidden = false
            }
        }
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
        self.navigationItem.title = "注册上链"
        self.view.backgroundColor = UIColor.white
    }
    fileprivate lazy var topLabel: UILabel = UILabel(title: "★ 您已获得认证中心签发的证书，您的认证证书现已提交委员会审核", fontSize: 16, color: UIColor.black, redundance: 60)
    fileprivate lazy var middleLabel: UILabel = UILabel(title: "★ 了保证链上身份信息的真实可靠，委员会需要对您的认证证书进行验证，以完成钱包地址的链上注册，这个过程需要一定的时间", fontSize: 16, color: UIColor.black, redundance: 60)
    fileprivate lazy var chainStateLabel: UILabel = {
        let temp = UILabel(title: "", fontSize: 30, color: UIColor(red: 40/255, green: 113/255, blue: 251/255, alpha: 1.0), redundance: 0)
        return temp
    }()
    fileprivate lazy var mentionLabel: UILabel = {
        let temp = UILabel(title: "您提交的认证证书，以及钱包地址信息，委员会未能验证通过，请重新提交", fontSize: 16, color: UIColor.red, redundance: 60)
        temp.isHidden = true
        return temp
    }()
    fileprivate lazy var nextBtn: UIButton = {
        let temp = UIButton(title: "重新提交", fontSize: 20, color: UIColor.white, imageName: nil, backColor: UIColor(red: 40/255, green: 113/255, blue: 251/255, alpha: 1.0))
        temp.addTarget(self, action: #selector(USEKYCRegisteToChainVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        temp.layer.cornerRadius = 20
        temp.isHidden = true
        return temp
    }()
}

extension USEKYCRegisteToChainVC {
    fileprivate func setupUI() {
        self.view.addSubview(topLabel)
        self.view.addSubview(middleLabel)
        self.view.addSubview(chainStateLabel)
        self.view.addSubview(mentionLabel)
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
        chainStateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(middleLabel.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
        }
        mentionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(middleLabel.snp.bottom).offset(30)
            make.left.equalTo(middleLabel)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.top.equalTo(mentionLabel.snp.bottom).offset(30)
            make.height.equalTo(40)
            make.width.equalTo(160)
            make.centerX.equalTo(self.view)
        }
    }
    
}
