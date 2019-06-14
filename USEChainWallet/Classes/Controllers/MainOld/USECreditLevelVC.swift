//
//  USECreditLevelVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/4/16.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USECreditLevelVC: USEWalletBaseVC {

    override func loadView() {
        super.loadView()
        let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let currentAddress = "0x" + useCurrentAccountArray!.last!
        let umAddress = kGetCurrentAccountUMAdderss()
        let combineUrlStr = String(format: "address/%@", umAddress)
        UseWalletNetworkTools.sharedUSEBrowser()?.request("GET", urlString: combineUrlStr, parameters: nil, finished: { (result, error) in
            if let resultDict = result as? [String: Any] {
                if resultDict["Error"] as! String != "" {
                    return
                }
                let dataDict = resultDict["Data"] as? [String: Any]
                if  (resultDict["Error"] as! String == "") && (dataDict?.keys.count == 0) {
                     self.transactionLabelNum.text = "0"
                    return
                }
                let tradePoints = dataDict!["tradePoints"]
                self.transactionLabelNum.text = "\(tradePoints!)"
                let auditingPoints = dataDict!["certifications"]
                self.auditingLabelNum.text = "\(auditingPoints!)"
            } else {
                return
            }
        })
        
        UseChainNetTools.getAccountStatus(address:  currentAddress as NSString) { (result, error) in
            let chainStateHex = (result as! [String: Any])["result"] as! String
            if (chainStateHex.hexToUInt256?.value == 3 || chainStateHex.hexToUInt256?.value == 11) {
                self.auditingImage.image = UIImage.init(named: "认证标志")
            } else {
                self.auditingImage.image = UIImage.init(named: "匿名标志")
            }
        }
        
        setupUI()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "信用等级"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    fileprivate lazy var addressLabel: UILabel = {
        let umAddress = kGetCurrentAccountUMAdderss()
        let temp = UILabel(title: umAddress, fontSize: 16, color: UIColor.black, redundance: 150)
        return temp
    }()
    fileprivate lazy var auditingImage: UIImageView = {
        let temp = UIImageView(image: UIImage.init(named: "匿名标志"), highlightedImage: nil)
        return temp
    }()
    fileprivate lazy var creditLevelImage: UIImageView = {
        let temp = UIImageView(image: UIImage.init(named: "钻石标志"), highlightedImage: nil)
        return temp
    }()
    fileprivate lazy var topLineView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.black
        return temp
    }()
    fileprivate lazy var verticalLineView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.black
        return temp
    }()
    fileprivate lazy var bottomLineView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.black
        return temp
    }()
    fileprivate lazy var auditingLabel: UILabel = UILabel(title: "认证分", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var transactionLabel: UILabel = UILabel(title: "交易分", fontSize: 18, color: UIColor.black, redundance: 18)
    fileprivate lazy var auditingLabelNum: UILabel = UILabel(title: "0", fontSize: 20, color: UIColor.black, redundance: 0)
    fileprivate lazy var transactionLabelNum: UILabel = UILabel(title: "0", fontSize: 20, color: UIColor.black, redundance: 0)
    fileprivate lazy var firstIntroductionTitleLabel: UILabel = UILabel(title: "1.分为信用等级", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var firstIntroductionLabel: UILabel = UILabel(title: "blablabalablbal", fontSize: 16, color: UIColor.gray, redundance: 40)
    fileprivate lazy var secondIntroductionTitleLabel: UILabel = UILabel(title: "2.什么是认证分", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var secondIntroductionLabel: UILabel = UILabel(title: "blablaablbal", fontSize: 16, color: UIColor.gray, redundance: 40)
    fileprivate lazy var thirdIntroductionTitleLabel: UILabel = UILabel(title: "3.信用级别可以做什么", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var thirdIntroductionLabel: UILabel = UILabel(title: "blabalbal", fontSize: 16, color: UIColor.gray, redundance: 40)
    
}

extension USECreditLevelVC {
    
    fileprivate func setupUI() {
        self.view.addSubview(addressLabel)
        self.view.addSubview(auditingImage)
        self.view.addSubview(creditLevelImage)
        self.view.addSubview(topLineView)
        self.view.addSubview(verticalLineView)
        self.view.addSubview(bottomLineView)
        self.view.addSubview(auditingLabel)
        self.view.addSubview(transactionLabel)
        self.view.addSubview(auditingLabelNum)
        self.view.addSubview(transactionLabelNum)
        self.view.addSubview(firstIntroductionTitleLabel)
        self.view.addSubview(firstIntroductionLabel)
        self.view.addSubview(secondIntroductionTitleLabel)
        self.view.addSubview(secondIntroductionLabel)
        self.view.addSubview(thirdIntroductionTitleLabel)
        self.view.addSubview(thirdIntroductionLabel)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(20)
        }
        auditingImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(addressLabel)
            make.right.equalTo(self.view).offset(-60)
            make.width.height.equalTo(30)
        }
        creditLevelImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(addressLabel)
            make.left.equalTo(auditingImage.snp.right).offset(10)
            make.width.height.equalTo(30)
        }
        topLineView.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom).offset(30)
            make.height.equalTo(1)
            make.left.right.equalTo(self.view)
        }
        verticalLineView.snp.makeConstraints { (make) in
            make.top.equalTo(topLineView.snp.bottom)
            make.centerX.equalTo(topLineView)
            make.width.equalTo(1)
            make.height.equalTo(80)
        }
        bottomLineView.snp.makeConstraints { (make) in
            make.top.equalTo(verticalLineView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(1)
        }
        auditingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLineView.snp.bottom).offset(10)
            make.centerX.equalTo(self.view.snp.centerX).offset(-(UIScreen.main.bounds.size.width / 4))
        }
        auditingLabelNum.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.bottomLineView.snp.top).offset(-10)
            make.centerX.equalTo(auditingLabel)
        }
        transactionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLineView.snp.bottom).offset(10)
            make.centerX.equalTo(self.view.snp.centerX).offset((UIScreen.main.bounds.size.width / 4))
        }
        transactionLabelNum.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.bottomLineView.snp.top).offset(-10)
            make.centerX.equalTo(transactionLabel)
        }
        firstIntroductionTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomLineView.snp.bottom).offset(30)
            make.left.equalTo(self.view.snp.left).offset(20)
        }
        firstIntroductionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstIntroductionTitleLabel.snp.bottom).offset(20)
            make.left.equalTo(firstIntroductionTitleLabel)
        }
        secondIntroductionTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstIntroductionLabel.snp.bottom).offset(30)
            make.left.equalTo(firstIntroductionLabel)
        }
        secondIntroductionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondIntroductionTitleLabel.snp.bottom).offset(20)
            make.left.equalTo(secondIntroductionTitleLabel)
        }
        thirdIntroductionTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondIntroductionLabel.snp.bottom).offset(30)
            make.left.equalTo(secondIntroductionLabel)
        }
        thirdIntroductionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thirdIntroductionTitleLabel.snp.bottom).offset(20)
            make.left.equalTo(thirdIntroductionTitleLabel)
        }
    }
    
}
