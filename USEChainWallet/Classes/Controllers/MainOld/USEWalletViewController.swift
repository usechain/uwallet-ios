//
//  USEWalletViewController.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/1.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEWalletAssetCellID = "USEWalletAssetCellID"

class USEWalletViewController: UIViewController {

    @objc private func clickedBtn(btn: UIButton) {
        
        switch btn.tag {
        case USEWalletVCBtnTag.qrcodeRefund.rawValue:
            self.navigationController?.pushViewController(USEQRCodeRefundVC(), animated: true)
        case USEWalletVCBtnTag.walletAdministrator.rawValue:
        self.navigationController?.pushViewController(USEWalletAdministraterVC(), animated: true)
        case USEWalletVCBtnTag.addressCopy.rawValue:
            let pasteboard = UIPasteboard.general
            let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
            if accountInfo != nil {
                let umAddress = kGetCurrentAccountUMAdderss()
                let walletAddress = umAddress
                pasteboard.string = walletAddress
            }
            showAlterView("地址复制成功", mySelf: self)
            case USEWalletVCBtnTag.auditing.rawValue:
                let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
                let currentAddress = "0x" + (accountInfo?.last)!
                UseChainNetTools.getAccountStatus(address: currentAddress as NSString) { (result, error) in
                    if result == nil {
                        showAlterView("网络出错", mySelf: self)
                        return
                    }
                    var chainStateHex = (result as! [String: Any])["result"] as! String
                    // 16进制转10进制
                    if (chainStateHex.hexToUInt256?.value == 1 || chainStateHex.hexToUInt256?.value == 2 || chainStateHex.hexToUInt256?.value == 9 || chainStateHex.hexToUInt256?.value == 10) {
                       //审核中
                        self.navigationController?.pushViewController(USEKYCRegisteToChainVC(), animated: true)
                        return
                    }
                    
                    if (chainStateHex.hexToUInt256?.value == 3 || chainStateHex.hexToUInt256?.value == 11) {
                        // 认证成功
                        self.navigationController?.pushViewController(USEKYCRegisteToChainVC(), animated: true)
                        return
                    } else {
                        // 认证失败 继续走之前的流程
                        // 升级
                        // 根据 Auditing地址 判断改地址是否有状态
                        // 如果有状态 跳到KYC最后的页面
                        // 如果没有状态 跳到KYC第一个页面
                        let auditingKey = "Auditing" + accountInfo!.last!
                        if (UserDefaults.standard.value(forKey: auditingKey) != nil) {
                            self.navigationController?.pushViewController(USEKYCAuditingVC(), animated: true)
                            return
                        }  else {
                            self.navigationController?.pushViewController(USEKYCInfoVC(), animated: true)
                        }
                    }
            }
            case USEWalletVCBtnTag.creditLevel.rawValue:
                    self.navigationController?.pushViewController(USECreditLevelVC(), animated: true)
        default:
            return
        }
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
        prepareTableView()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        if accountInfo != nil {
            let walletName = accountInfo?.first
            hostWallet.text = walletName
            let umAddress = kGetCurrentAccountUMAdderss()
            address.text = umAddress.ellipsisMiddleSting

            UseChainNetTools.getUSEBalance(address: umAddress) { (result, error) in
                if result != nil {
                    let resultBalance = (result as! [String: Any])["result"] as! String
                    let bigNumResultBalance = BigNumber(hexString: resultBalance)
                    let tempStr = Payment.formatEther(bigNumResultBalance, options: (EtherFormatOption.commify.rawValue | EtherFormatOption.approximate.rawValue))
                   
                    self.tempBalance = tempStr ?? "0"
                    self.assetTableview.reloadData()
                    UseChainNetTools.getTokenInfo(address: "0xd9485499499d66b175cf5ed54c0a19f1a6bcb61a") { (result, error) in
                        if result != nil {
                            if (result as! [String: Any])["price"] != nil {
                                let rate = ((result as! [String: Any])["price"] as! [String: Any])["rate"] as! Double
                                let price = rate * 6.9027
                                self.estimateMoney.text = "≈ ¥ " + String(format: "%.3f", (tempStr! as NSString).doubleValue * price)
                            }
                        }
                            self.assetTableview.reloadData()
                    }
                }
            }
            let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
            let currentAddress = "0x" + useCurrentAccountArray!.last!
            print(currentAddress)
            UseChainNetTools.getAccountStatus(address:  currentAddress as NSString) { (result, error) in
                if result == nil {
                    showAlterView("网络出错", mySelf: self)
                    return
                }
                let chainStateHex = (result as! [String: Any])["result"] as! String
                // 16进制转10进制
                if (chainStateHex.hexToUInt256?.value == 3 || chainStateHex.hexToUInt256?.value == 11) {
                    // 认证成功
                    self.auditingBtn.setImage(UIImage.init(named: "认证标志"), for: UIControl.State.normal)
                } else {
                    // 认证失败
                    self.auditingBtn.setImage(UIImage.init(named: "匿名标志"), for: UIControl.State.normal)
                }
            }
            
        }

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    //MARK: -LazyloadKit
    fileprivate var tempBalance: String?
    fileprivate lazy var topBackView: UIImageView = {
        let temp = UIImageView()
        temp.image = UIImage.init(named: "bg2")?.withRenderingMode(.alwaysOriginal)
        temp.isUserInteractionEnabled = true
        return temp
    }()
    fileprivate lazy var qrCodeBtn: UIButton = {
        let temp = UIButton()
        temp.setImage(UIImage.init(named: "erweima"), for: UIControl.State.normal)
        temp.tag = USEWalletVCBtnTag.qrcodeRefund.rawValue
        temp.addTarget(self, action: #selector(USEWalletViewController.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    fileprivate lazy var walletManagerBtn: UIButton =  {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "qianbao"), for: UIControl.State.normal)
        btn.tag = USEWalletVCBtnTag.walletAdministrator.rawValue
        btn.addTarget(self, action: #selector(USEWalletViewController.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    fileprivate lazy var hostWallet: UILabel = UILabel(title: "小优的钱包", fontSize: 15, color: UIColor.white, redundance: 0)
    fileprivate lazy var address: UILabel = UILabel(title: "0xSDWWERF...SDA23FD", fontSize: 15, color: UIColor.white, redundance: 0)
    fileprivate lazy var copyBtn: UIButton = {
        let temp = UIButton(title: "", fontSize: 10, color: UIColor.white, imageName: "copy")
        temp.addTarget(self, action: #selector(USEWalletViewController.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        temp.tag = USEWalletVCBtnTag.addressCopy.rawValue
        return temp
    }()
    
    fileprivate lazy var clientBtn: UIButton = UIButton(title: "", fontSize: 15, color: UIColor.black, imageName: "u100")
    fileprivate lazy var estimateMoney: UILabel = UILabel(title: "≈ ¥0", fontSize: 20, color: UIColor.white, redundance: 0)
    
    fileprivate lazy var assetLabel: UILabel = UILabel(title: "资产", fontSize: 15, color: UIColor.black, redundance: 0)
    fileprivate lazy var addAssetBtn: UIButton = UIButton(title: "", fontSize: 15, color: UIColor.black, imageName: "u1413")
    
    fileprivate lazy var assetTableview: UITableView = UITableView()
    
    fileprivate lazy var auditingBtn: UIButton = {
        let temp = UIButton(imageName: "匿名标志", backImageName: "")
        temp.addTarget(self, action: #selector(USEWalletViewController.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        temp.tag = USEWalletVCBtnTag.auditing.rawValue
        return temp
    }()
    fileprivate lazy var creditLevelBtn: UIButton = {
        let temp = UIButton(imageName: "钻石标志", backImageName: nil)
        temp.addTarget(self, action: #selector(USEWalletViewController.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        temp.tag = USEWalletVCBtnTag.creditLevel.rawValue
        return temp
    }()
}

extension USEWalletViewController {
    fileprivate func setupUI() {
        // addSubviews
        self.view.addSubview(topBackView)
        
        topBackView.addSubview(qrCodeBtn)
        topBackView.addSubview(walletManagerBtn)
        
        topBackView.addSubview(hostWallet)
        topBackView.addSubview(address)
        topBackView.addSubview(copyBtn)

        topBackView.addSubview(clientBtn)
        topBackView.addSubview(auditingBtn)
        topBackView.addSubview(creditLevelBtn)
        topBackView.addSubview(estimateMoney)
        
        self.view.addSubview(assetLabel)
        self.view.addSubview(addAssetBtn)
        
        self.view.addSubview(assetTableview)
        
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        // layout
        topBackView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(270)
        }
        qrCodeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.topBackView).offset(40)
            make.left.equalTo(self.topBackView).offset(5)
            make.width.height.equalTo(50)
        }
        walletManagerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.topBackView).offset(40)
            make.right.equalTo(self.topBackView).offset(-5)
            make.width.height.equalTo(50)
        }
        hostWallet.snp.makeConstraints { (make) in
            make.top.equalTo(qrCodeBtn.snp.bottom).offset(40)
            make.left.equalTo(qrCodeBtn).offset(20)
        }
        address.snp.makeConstraints { (make) in
            make.top.equalTo(hostWallet.snp.bottom).offset(10)
            make.left.equalTo(hostWallet.snp.left)
        }
        copyBtn.snp.makeConstraints { (make) in
            make.top.equalTo(address)
            make.left.equalTo(address.snp.right).offset(10)
            make.height.width.equalTo(20)
        }
        clientBtn.snp.makeConstraints { (make) in
            make.top.equalTo(hostWallet)
            make.right.equalTo(topBackView).offset(-30)
            make.height.width.equalTo(40)
        }
        auditingBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(copyBtn)
            make.right.equalTo(self.view.snp.right).offset(-60)
            make.width.height.equalTo(30)
        }
        creditLevelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(auditingBtn)
            make.left.equalTo(auditingBtn.snp.right).offset(10)
            make.width.height.equalTo(30)
        }
        
        estimateMoney.snp.makeConstraints { (make) in
            make.top.equalTo(clientBtn.snp.bottom).offset(20)
            make.right.equalTo(topBackView).offset(-20)
        }
        
        assetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topBackView.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(20)
        }
        addAssetBtn.snp.makeConstraints { (make) in
            make.top.equalTo(assetLabel)
            make.right.equalTo(self.view).offset(-20)
            make.height.width.equalTo(30)
        }
        assetTableview.snp.makeConstraints { (make) in
            make.top.equalTo(addAssetBtn.snp.bottom).offset(20)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.bottom)
        }
    }
}

extension USEWalletViewController: UITableViewDelegate, UITableViewDataSource {
    fileprivate func prepareTableView() {
        assetTableview.delegate = self
        assetTableview.dataSource = self
        assetTableview.register(USEWalletAssetCell.self, forCellReuseIdentifier: USEWalletAssetCellID)
        assetTableview.tableFooterView = UIView()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: USEWalletAssetCellID) as! USEWalletAssetCell
        cell.coinCount.text = tempBalance
        cell.estimateRMB.text = self.estimateMoney.text
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           self.navigationController?.pushViewController(USECoinDetailVC(), animated: true)
    }
}
