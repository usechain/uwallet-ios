//
//  USEWalletDetailVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/19.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEWalletDetailTopCellID = "USEWalletDetailTopCellID"
private let USEWalletDetailMiddleCellID = "USEWalletDetailMiddleCellID"
private let USEWalletDetailBottomCellID = "USEWalletDetailBottomCellID"


class USEWalletDetailVC: USEWalletBaseVC {
    
    override func loadView() {
        super.loadView()
        setupUI()
        prepareTableview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "钱包详情"
        self.view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        let currentAddress = "0x" + walletInfo.last!
        self.showHUD()
        UseChainNetTools.getAccountStatus(address: currentAddress as NSString) { (result, error) in
            self.hideHUD()
            if (result == nil) {
                showAlterView("网络出错", mySelf: self)
                return
            }
            let chainStateHex = (result as! [String: Any])["result"] as! String
            let status = chainStateHex.hexToUInt256!.value
            
            let signIP = NSIndexPath(row: 0, section: 0)
            let topCell = self.tabView.cellForRow(at: signIP as IndexPath) as! USEWalletDetailTopCell
           
            switch status {
                // 0-4 主账号
            case 0:
                // 未上链注册
                self.isVerified = false
            case 1:
                // 未审核
                self.isVerified = false
            case 2:
                // 审核中
                self.isVerified = false
            case 3:
                // 审核通过
                self.isVerified = true
                 topCell.authImageView.image = UIImage(named: "认证标志")
            case 4:
                // 审核拒绝
                self.isVerified = false
                // 0-4 (+8) 子账号
            case 8:
                // 未上链注册
                self.isVerified = false
            case 9:
                // 未审核
                self.isVerified = false
            case 10:
                // 审核中
                self.isVerified = false
            case 11:
                // 审核通过
                self.isVerified = true
                 topCell.authImageView.image = UIImage(named: "认证标志")
            case 12:
                // 审核拒绝
                self.isVerified = false
                
            default:
                // 错误
                self.isVerified = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      //  isVerified = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    // MARK: -LazylaodKit
    fileprivate lazy var tabView: UITableView = {
        let temp = UITableView()
        return temp
    }()
    fileprivate lazy var tabTitleArray: Array = { () -> [String] in
        let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let parentAccontInfoHalfKey = "parentAccontInfoHalfKey"
        let parentAccontInfoKey = parentAccontInfoHalfKey + useCurrentAccountArray!.last!
        if UserDefaults.standard.value(forKey: parentAccontInfoKey) != nil {
            let temp = ["KYC认证升级", "修改密码", "导出私钥", "导出keystore", "子账号认证", "修改钱包名称"]
            return temp
        }
        let temp = ["KYC认证升级", "修改密码", "导出私钥", "导出keystore", "子账号生成", "修改钱包名称"]
        return temp
    }()
    
    var isSubAccount: Bool = {
        let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let parentAccontInfoHalfKey = "parentAccontInfoHalfKey"
        let parentAccontInfoKey = parentAccontInfoHalfKey + useCurrentAccountArray!.last!
        if UserDefaults.standard.value(forKey: parentAccontInfoKey) != nil {
            return true
        }
        return false
    }()
    
    fileprivate lazy var tabImageArray: Array = { () -> [String] in
        let temp = ["me_2", "xiugai", "siyao", "daochu", "me_2", "xiugai"]
        return temp
    }()
    fileprivate  var walletInfo: Array = { () -> [String] in
        let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        return useCurrentAccountArray ?? []
    }()
    var isVerified: Bool?
}

extension USEWalletDetailVC {
    fileprivate func setupUI() {
        //addSubviews
        self.view.addSubview(tabView)

        
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        tabView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }

    }
    fileprivate func prepareTableview() {
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView()
        tabView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        tabView.register(USEWalletDetailTopCell.self, forCellReuseIdentifier: USEWalletDetailTopCellID)
        tabView.register(USEWalletDetailMiddleCell.self, forCellReuseIdentifier: USEWalletDetailMiddleCellID)
        tabView.register(USEWalletDetailBottomCell.self, forCellReuseIdentifier: USEWalletDetailBottomCellID)
        tabView.separatorStyle = .none
    }
}

extension USEWalletDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: USEWalletDetailTopCellID) as! USEWalletDetailTopCell
            cell.nameLabel.text = kGetCurrentAccoountWalletName()
            // um
            let umAddress = kGetCurrentAccountUMAdderss()
            cell.addressLabel.text = umAddress.ellipsisMiddleSting
            return cell
        } else if indexPath.item == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: USEWalletDetailBottomCellID) as! USEWalletDetailBottomCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: USEWalletDetailMiddleCellID) as! USEWalletDetailMiddleCell
            cell.leftImageView.image = UIImage.init(named: tabImageArray[indexPath.row - 1])
            cell.titleLabel.text = tabTitleArray[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 120
        } else if indexPath.item == 7 {
            return 100
        } else {
            return 60
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            if isVerified! {
                self.navigationController?.pushViewController(USEKYCRegisteToChainVC(), animated: true)
                return
            }

            let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
            let auditingKey = "Auditing" + (accountInfo?.last!)!
            if (UserDefaults.standard.value(forKey: auditingKey) != nil) {
                self.navigationController?.pushViewController(USEKYCAuditingVC(), animated: true)
            } else {
                self.navigationController?.pushViewController(USEKYCInfoVC(), animated: true)
            }
        } else if indexPath.row == 2 {
            // 修改密码
    
            self.navigationController?.pushViewController(USEChangePasscodeVC(), animated: true)
        } else if indexPath.row == 3 {
            // 导出私钥
            // walletStore对应的密码
            let walletStore = walletInfo[1]
            let correctPasscode = (UserDefaults.standard.value(forKey: walletStore) as! Array<String>).last
            let alertVC = UIAlertController(title: "请输入密码", message: "", preferredStyle: .alert)
            let cancelBtn = UIAlertAction(title: "取消", style: .cancel) { (action) in
                print("取消")
            }
            let confirmBtn = UIAlertAction(title: "确认", style: .destructive) { (action) in
                print("确认")
                let textField = alertVC.textFields?.first
                if textField?.text == correctPasscode {
                        self.navigationController?.pushViewController(USEExportPrivateKeyVC(), animated: true)
                } else {
                        showAlterView("密码错误", mySelf: self)
                }
            }
            confirmBtn.setValue(UIColor.red, forKey: "titleTextColor")
            alertVC.addAction(cancelBtn)
            alertVC.addAction(confirmBtn)
            alertVC.addTextField { (textfiled) in
                textfiled.placeholder = "请输入密码"
            }
            self.present(alertVC, animated: true) {
            }
        } else if indexPath.row == 4 {
            // 导出keystore
            // walletStore对应的密码
            let walletStore = walletInfo[1]
            let correctPasscode = (UserDefaults.standard.value(forKey: walletStore) as! Array<String>).last
            let alertVC = UIAlertController(title: "请输入密码", message: "", preferredStyle: .alert)
            let cancelBtn = UIAlertAction(title: "取消", style: .cancel) { (action) in
                print("取消")
            }
            let confirmBtn = UIAlertAction(title: "确认", style: .destructive) { (action) in
                print("确认")
                let textField = alertVC.textFields?.first
                if textField?.text == correctPasscode {
                    self.navigationController?.pushViewController(USEExportKeystoreVC(), animated: true)
                } else {
                    showAlterView("密码错误", mySelf: self)
                }
            }
            confirmBtn.setValue(UIColor.red, forKey: "titleTextColor")
            alertVC.addAction(cancelBtn)
            alertVC.addAction(confirmBtn)
            alertVC.addTextField { (textfiled) in
                textfiled.placeholder = "请输入密码"
            }
            dispatch_sync_on_main_queue {
                self.present(alertVC, animated: true, completion: nil)
            }

        } else if indexPath.row == 7 {
            // 删除钱包
            let walletStore = walletInfo[1]
            let correctPasscode = (UserDefaults.standard.value(forKey: walletStore) as! Array<String>).last
            let alertVC = UIAlertController(title: "请输入密码", message: "", preferredStyle: .alert)
            let cancelBtn = UIAlertAction(title: "取消", style: .cancel) { (action) in
                print("取消")
            }
            let confirmBtn = UIAlertAction(title: "确认", style: .destructive) { (action) in
                print("确认")
                let textField = alertVC.textFields?.first
                // 密码校验
                if textField?.text == correctPasscode {
                    let mnemonicArray = UserDefaults.standard.value(forKey: "USEUserWallets") as? Array<String>
                   
                    let currentM = self.walletInfo[1]
                    print(currentM)
                    var removedMnmonicArray: Array<Any> = []
                    if mnemonicArray?.count != 0 {
                        for i in mnemonicArray ?? Array() {
                            if i == currentM {
                                var recoverArray: Array<String> = []
                                if UserDefaults.standard.value(forKey: kRecoverWalletsKey) != nil {
                                    recoverArray =  (UserDefaults.standard.value(forKey: kRecoverWalletsKey) as! Array<String>)
                                    recoverArray.append(i)
                                    UserDefaults.standard.setValue(recoverArray, forKey: kRecoverWalletsKey)
                                } else {
                                    recoverArray.append(i)
                                    UserDefaults.standard.setValue(recoverArray, forKey: kRecoverWalletsKey)
                                }
                                continue
                            }
                            removedMnmonicArray.append(i)
                        }
                        UserDefaults.standard.setValue(removedMnmonicArray, forKey: "USEUserWallets")
                    }
                    let privateKeyArray = UserDefaults.standard.value(forKey: "USEUserPrivateKeyWallets") as? Array<String>
                    let currentP = self.walletInfo[1]
                    print(currentP)
                    var removedPrivateArray: Array<String> = []
                    if privateKeyArray?.count != 0 {
                        for i in privateKeyArray ?? Array() {
                            if i == currentP {
                                var recoverArrayP: Array<String> = []
                                if UserDefaults.standard.value(forKey: kRecoverWalletsKey) != nil {
                                    recoverArrayP =  (UserDefaults.standard.value(forKey: kRecoverWalletsKey) as! Array<String>)
                                    recoverArrayP.append(i)
                                    UserDefaults.standard.setValue(recoverArrayP, forKey: kRecoverWalletsKey)
                                } else {
                                    recoverArrayP.append(i)
                                    UserDefaults.standard.setValue(recoverArrayP, forKey: kRecoverWalletsKey)
                                }
                                continue
                            }
                            removedPrivateArray.append(i)
                        }
                        UserDefaults.standard.setValue(removedPrivateArray, forKey: "USEUserPrivateKeyWallets")
                    }
                    
                    if removedMnmonicArray.count == 0 && removedPrivateArray.count == 0 {

                        let nilArray: Array<Any> = []
                        UserDefaults.standard.setValue(nilArray, forKey: kUSECurrentAccountInfo)
                        self.navigationController?.pushViewController(USEWalletMainNewVC(), animated: true)
                    } else {
                        if removedMnmonicArray.count != 0 {
                            let contentArray = UserDefaults.standard.value(forKey: removedMnmonicArray.first as! String) as? Array<String>
                            let walletName = contentArray?.first
                            let walletMiddleInfo = removedMnmonicArray.first
                            let walletAddress = UseEthersManager(mnemonicPhrase: (walletMiddleInfo as! String), slot: 0)?.address.data.toHexString()
                            UserDefaults.standard.setValue([walletName, walletMiddleInfo, walletAddress], forKey: kUSECurrentAccountInfo)
                            self.navigationController?.popViewController(animated: true)
                            return
                        }
                        if removedPrivateArray.count != 0 {
                            let contentArray = UserDefaults.standard.value(forKey: removedPrivateArray.first!) as? Array<String>
                            let walletName = contentArray?.first
                            let walletMiddleInfo = removedPrivateArray.first
                            let walletAddress = UseEthersManager(privateKey: removedPrivateArray.first?.hexToBytes)?.address.data.toHexString()
                            UserDefaults.standard.setValue([walletName, walletMiddleInfo, walletAddress], forKey: kUSECurrentAccountInfo)
                            self.navigationController?.popViewController(animated: true)
                            return
                        }
                    }
                } else {
                    showAlterView("密码错误", mySelf: self)
                    return
                }
            }
            confirmBtn.setValue(UIColor.red, forKey: "titleTextColor")
            alertVC.addAction(cancelBtn)
            alertVC.addAction(confirmBtn)
            alertVC.addTextField { (textfiled) in
                textfiled.placeholder = "请输入密码"
            }
            self.present(alertVC, animated: true) {
                
            }
        } else if indexPath.row == 5 {
            if isSubAccount {
                self.navigationController?.pushViewController(USESubAccountAuditingVC(), animated: true)
            } else {
                self.navigationController?.pushViewController(USEGenerateSubAccountVC(), animated: true)
            }
        } else if indexPath.row == 6 {
            let alertVC = UIAlertController(title: "请输入新的钱包名称", message: "", preferredStyle: .alert)
            let cancelBtn = UIAlertAction(title: "取消", style: .cancel) { (action) in
                print("取消")
            }
            let confirmBtn = UIAlertAction(title: "确认", style: .destructive) { (action) in
                let textField = alertVC.textFields?.first
                let currentAccountInfo = kGetCurrentAccountInfo()
                let walletStore = self.walletInfo[1]
                let correctPasscode = (UserDefaults.standard.value(forKey: walletStore) as! Array<String>).last
                UserDefaults.standard.setValue([(textField?.text!), correctPasscode], forKey: walletStore)
                UserDefaults.standard.setValue([textField?.text!, walletStore, currentAccountInfo[2].lowercased()], forKey: kUSECurrentAccountInfo)
                self.tabView.reloadData()
            }
            confirmBtn.setValue(UIColor.red, forKey: "titleTextColor")
            alertVC.addAction(cancelBtn)
            alertVC.addAction(confirmBtn)
            alertVC.addTextField { (textfiled) in
                textfiled.placeholder = "钱包名称"
            }
            self.present(alertVC, animated: true) {
            }
        }
    }
}
