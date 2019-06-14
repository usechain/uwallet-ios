//
//  USEKYCAuditingVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/21.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit
import HSCryptoKit
import BigInt

private let USEKYCConfirmInfoCellID = "USEKYCConfirmInfoCellID"
private let USEKYCConfirmBtnCellID = "USEKYCConfirmBtnCellID"
private let USEKYCAuditingStateCellID = "USEKYCAuditingStateCellID"

class USEKYCAuditingVC: USEWalletBaseVC {
    
    override func clickBtn() {
            for controller in (self.navigationController?.viewControllers)! {
            if controller.isKind(of: USEWalletDetailVC.self) {
            self.navigationController?.popToViewController(controller, animated: true)
                return
                    }
            }
        for controller in (self.navigationController?.viewControllers)! {
            if controller.isKind(of: USEWalletMainOldVC.self) {
                self.navigationController?.popToViewController(controller, animated: true)
                return
            }
        }
    }

    override func loadView() {
        super.loadView()
        setupUI()
        prepareTableView()
        // 发csr请求证书
        let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let KYCUserKey = "KYCUserInfo" + accountInfo!.last!
        let userDict = UserDefaults.standard.value(forKey: KYCUserKey) as! [String: Any]
        print(userDict)
        // Setp1: 生成csr
        // info 里的两个参数 分别是 hash(certType-id) 和 hash(data)
        // hash(certType-id)
        let str = userDict["id"] as! String
        let certTypeStr = userDict["certtype"] as! String
        let certypeAndId = certTypeStr + "-" + str
        
        let hashData = certypeAndId.data(using: String.Encoding.utf8)
        let hashCertWithIdHex = "0x" + CryptoKit.sha3(hashData!).toHexString()
        // 这块对于hash(usrdict)的处理 要给出一个固定的顺序 保证每一次运行的结果相同
        let dictData = try! JSONSerialization.data(withJSONObject: userDict, options: [.sortedKeys])
        
/*        {
            addr = "";
            birthday = "2019-01-01";
            certtype = 1;
            ename = "";
            id = 210123098789098908;
            name = "\U9ec4\U6587\U6c49";
            nation = cn;
            sex = 1;
      }
 */
        let hashUserDataHex = "0x" + CryptoKit.sha3(dictData).toHexString()
         let KYCUserCerttypeIdAndDataHashKey = "KYCUserCerttypeIdAndDataHash" + accountInfo!.last!
        UserDefaults.standard.setValue([hashCertWithIdHex, hashUserDataHex], forKey: KYCUserCerttypeIdAndDataHashKey)
        // Setp2: 拿到csr
        let csr =  UseEthersManager.generateCsr(hashCertWithIdHex, andHashUserData: hashUserDataHex)
        UseWalletNetworkTools.sharedCA()?.upload(csr, userdata: userDict, urlString: "", parameters: nil, finished: { (result, error) in
            if result != nil {
                let idKeyDict = ((result as! [String: Any])["data"]) as! [String: String]
                // Step3: 拿到证书
                UseWalletNetworkTools.sharedGetCRT()?.request("GET", urlString: "", parameters: idKeyDict, finished: { (result, error) in
                    let resultMsg = (result as! [String: Any])["msg"]
                    let status = (result as! [String: Any])["status"] as! Int
                    let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
                    let auditingKey = "Auditing" + accountInfo!.last!
                    if status != 0 {
                        if status == 5 {
                            print("审核中")
                            let cellIP = NSIndexPath(row: 4, section: 0)
                            let cell = self.tabView.cellForRow(at: cellIP as IndexPath) as! USEKYCAuditingStateCell
                            cell.auditingLabel.text = "审核中"
                            let todaChainIP = NSIndexPath(row: 6, section: 0)
                            let todaChainCell = self.tabView.cellForRow(at: todaChainIP as IndexPath) as! USEKYCConfirmBtnCell
                            todaChainCell.confirmBtn.isHidden = true
                            let reConfirmIP = NSIndexPath(row: 5, section: 0)
                            let reConfirmCell = self.tabView.cellForRow(at: reConfirmIP as IndexPath) as! USEKYCConfirmBtnCell
                            reConfirmCell.confirmBtn.isHidden = true
                            UserDefaults.standard.setValue("审核中", forKey: auditingKey)
                            return
                        }
                        let failureResult = "审核失败" + (resultMsg as! String)
                        let cellIP = NSIndexPath(row: 4, section: 0)
                        let cell = self.tabView.cellForRow(at: cellIP as IndexPath) as! USEKYCAuditingStateCell
                        cell.auditingLabel.text = "审核失败"
                        showAlterView(failureResult, mySelf: self)
                        let reConfirmIP = NSIndexPath(row: 5, section: 0)
                        let reConfirmCell = self.tabView.cellForRow(at: reConfirmIP as IndexPath) as! USEKYCConfirmBtnCell
                        reConfirmCell.confirmBtn.isHidden = false
                        UserDefaults.standard.setValue("审核失败", forKey: auditingKey)
                        return
                    } else {
                        // 审核成功
                         showAlterView("审核成功", mySelf: self)
                       let certString = ((result as! [String: Any])["data"] as! [String: Any])["cert"] as! String
                        let KYCUserCertStringKey = "KYCUserCertStringKey" + accountInfo!.last!
                        UserDefaults.standard.setValue(certString, forKey: KYCUserCertStringKey)
                          let cellIP = NSIndexPath(row: 4, section: 0)
                          let cell = self.tabView.cellForRow(at: cellIP as IndexPath) as! USEKYCAuditingStateCell
                         cell.auditingLabel.text = "审核成功"
                        let todaChainIP = NSIndexPath(row: 6, section: 0)
                        let todaChainCell = self.tabView.cellForRow(at: todaChainIP as IndexPath) as! USEKYCConfirmBtnCell
                        todaChainCell.confirmBtn.isHidden = false
                        let reConfirmIP = NSIndexPath(row: 5, section: 0)
                        let reConfirmCell = self.tabView.cellForRow(at: reConfirmIP as IndexPath) as! USEKYCConfirmBtnCell
                        reConfirmCell.confirmBtn.isHidden = true
                        UserDefaults.standard.setValue("审核成功", forKey: auditingKey)
                    }
                })
            } else {
                let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
                let auditingKey = "Auditing" + accountInfo!.last!
                let failureResult = "审核失败"
                let cellIP = NSIndexPath(row: 4, section: 0)
                let cell = self.tabView.cellForRow(at: cellIP as IndexPath) as! USEKYCAuditingStateCell
                cell.auditingLabel.text = "审核失败"
                showAlterView(failureResult, mySelf: self)
                let reConfirmIP = NSIndexPath(row: 5, section: 0)
                let reConfirmCell = self.tabView.cellForRow(at: reConfirmIP as IndexPath) as! USEKYCConfirmBtnCell
                reConfirmCell.confirmBtn.isHidden = false
                UserDefaults.standard.setValue("审核失败", forKey: auditingKey)
                return
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userInfo = []
        let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let KYCUserKey = "KYCUserInfo" + accountInfo!.last!
        let userDict = UserDefaults.standard.value(forKey: KYCUserKey) as! [String: String]
        userInfo.append(userDict["nation"]!)
        userInfo.append("居民身份证")
        userInfo.append(userDict["name"]!)
        userInfo.append(userDict["id"]!)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let target = self.navigationController?.interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer.init(target: target, action: nil)
        self.view.addGestureRecognizer(pan)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "认证升级"
        self.view.backgroundColor = UIColor.white
        
    }
    
    fileprivate var userInfo: Array = [""]
    fileprivate var tablTitleArray: Array<String>?
    fileprivate lazy var tabView: UITableView = {
        let temp = UITableView()
        temp.tableFooterView = UIView()
        return temp
    }()
    fileprivate lazy var tabTitleArray: Array = { () -> [String] in
        let temp = ["国家/地区:", "证件类型:", "姓名:", "证件号码:"]
        return temp
    }()
    fileprivate lazy var walletInfo: Array = { () -> [String] in
        let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        return useCurrentAccountArray ?? []
    }()
}

extension USEKYCAuditingVC {
    fileprivate func setupUI() {
        self.view.addSubview(tabView)
        
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        tabView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(20)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    fileprivate func prepareTableView() {
        tabView.delegate = self as UITableViewDelegate
        tabView.dataSource = self
        tabView.register(USEKYCConfirmInfoCell.self, forCellReuseIdentifier: USEKYCConfirmInfoCellID)
                tabView.register(USEKYCAuditingStateCell.self, forCellReuseIdentifier: USEKYCAuditingStateCellID)
        tabView.register(USEKYCConfirmBtnCell.self, forCellReuseIdentifier: USEKYCConfirmBtnCellID)
        tabView.separatorStyle = .none
    }
}

extension USEKYCAuditingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row <= 3 {
            // plainText
            let cell = tableView.dequeueReusableCell(withIdentifier: USEKYCConfirmInfoCellID) as! USEKYCConfirmInfoCell
            cell.cellTitleLabel.text = tabTitleArray[indexPath.row]
            if userInfo.count != 0 {
                cell.cellContentLabel.text = userInfo[indexPath.row]
            }
            return cell
        } else if indexPath.row == 4 {
            // Auditing || Audited
            let cell = tabView.dequeueReusableCell(withIdentifier: USEKYCAuditingStateCellID) as! USEKYCAuditingStateCell

            return cell
        } else if indexPath.row == 5 {
            // Reauthenticate || RegisteToChain
            let cell = tabView.dequeueReusableCell(withIdentifier: USEKYCConfirmBtnCellID) as! USEKYCConfirmBtnCell
            cell.confirmBtn.setTitle("重新认证", for: UIControl.State.normal)
            cell.delegate  = self
            return cell
        } else {
            // Reauthenticate || RegisteToChain
            let cell = tabView.dequeueReusableCell(withIdentifier: USEKYCConfirmBtnCellID) as! USEKYCConfirmBtnCell
            cell.confirmBtn.setTitle("上链", for: UIControl.State.normal)
            cell.delegate  = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row <= 3 {
            // plainTextm
            return 44
        }  else if indexPath.row == 4 {
            // confirmBtn
            return 80
        } else {
            return 50
        }
    }
}

extension USEKYCAuditingVC: USEKYCConfirmBtnCellBtnClicked {
    func clicked(btn: UIButton) {
        if btn.titleLabel?.text == "重新认证" {
            for controller in (self.navigationController?.viewControllers)! {
                if controller.isKind(of: USEKYCAuthenticationVC.self) {
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            }
        } else if btn.titleLabel?.text == "上链"{
            let types = [
                ABIv2.Element.InOut(name: "1", type: .dynamicBytes),
                ABIv2.Element.InOut(name: "2", type: .bytes(length: 32)),
                ABIv2.Element.InOut(name: "3", type: .dynamicBytes),
                ABIv2.Element.InOut(name: "4", type: .dynamicBytes),
                ABIv2.Element.InOut(name: "5", type: .bool),
                ]
            let pubKeyStr = getCurrentWalletPubkey()
            let hashKeyHexStr = getHashCerttypeId()
            let data = ABIv2Encoder.encode(types: types, values: [pubKeyStr.toData(), hashKeyHexStr.hexToBytes, getIdentityWith(encryptPubKey: encryptPubKey(), fpr: getHashUsrData()), getIssuerData(), false] as [AnyObject])
            let addFunctionPrefixDataHexString = "0xcd1889d8" + (data?.toHexString())!
            toDaChain(abiCode: addFunctionPrefixDataHexString.hexToBytes!)
        }
        
    }
    fileprivate func toDaChain(abiCode: Data) {
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
                 self.view.showHUD(withText: "正在发送交易")
                let account = kGetCurrentAccount()
                UseChainNetTools.sendUSETransactionWith(account: account, gasLimite: "100000000", gasPrice: "1000000000", value: "0", toAddress: kF1ContractAddress, data: abiCode as NSData, flag: 0, resource: { (result, error) in

                    if result != nil {
                        self.view.hideHUD()
                        
                        if (result as! [String: Any])["error"] != nil {
                            showAlterView("交易发送失败", mySelf: self)
                            return
                        }
                        showAlterView("交易发送成功", mySelf: self)
                        UserDefaults.standard.setValue((result as! [String: Any])["result"], forKey: "currentTXHash")
                        
                        
                        self.navigationController?.pushViewController(USEKYCRegisteToChainVC(), animated: true)
                    } else {
                        showAlterView("交易发送失败", mySelf: self)
                    }
                })
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
    }
    // step-1: parameter--------pubKey
    fileprivate func getCurrentWalletPubkey() -> String {
        let currentAccount = kGetCurrentAccount()
        let currentPrivateKey: SecureData = SecureData(data: currentAccount.privateKey)
        print(currentPrivateKey.hexString())
        let currentPublicKey = Account.getPublicKey(withPrivateKey: currentAccount.privateKey)
        let separatedStrings = currentPublicKey!.description
        let array : Array = separatedStrings.components(separatedBy: "=")
        let currentPubKeyString = (array.last! as NSString).substring(to: 132)
        return currentPubKeyString
    }
    // step-2: parameter---------hash(certtype-id)
    fileprivate func getHashCerttypeId() -> String {
        let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let KYCUserCerttypeIdAndDataHashKey = "KYCUserCerttypeIdAndDataHash" + accountInfo!.last!
        let hashCerttypeIdStr = (UserDefaults.standard.value(forKey: KYCUserCerttypeIdAndDataHashKey) as! Array).first! as String
        return hashCerttypeIdStr
    }
    // step-3: parameter----------identity
    fileprivate func getIdentityWith(encryptPubKey: String, fpr: String) -> Data {
        let eciesEngine = ECIESEngine()
        // 截断communityPubKey的0x04
        let removePrefixEncryptPubKey = encryptPubKey.replacingOccurrences(of: "0x04", with: "")
        // 初始化message
         let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let KYCUserKey = "KYCUserInfo" + accountInfo!.last!
        let userDict = UserDefaults.standard.value(forKey: KYCUserKey) as! [String: Any]
        let message = String(format: "{\"addr\":\"%@\",\"birthday\":\"%@\",\"certtype\":\"%@\",\"ename\":\"%@\",\"id\":\"%@\",\"name\":\"%@\",\"nation\":\"%@\",\"sex\": \"%@\"}", userDict["addr"] as! String, userDict["birthday"] as! String, userDict["certtype"] as! String, userDict["ename"] as! String, userDict["id"] as! String, userDict["name"] as! String, userDict["nation"] as! String, userDict["sex"] as! String)
        let encryptPubKeyPoint = ECPoint(nodeId: Data(hex: removePrefixEncryptPubKey))
        let eciesEncrypt: ECIESEncryptedMessage = eciesEngine.encrypt(crypto: CryptoUtils.shared, randomHelper: RandomHelper.shared, remotePublicKey: encryptPubKeyPoint, message: message.toData())
        let encryptedDataStr = eciesEncrypt.ephemeralPublicKey.toHexString() + eciesEncrypt.initialVector.toHexString() + eciesEncrypt.cipher.toHexString() + eciesEncrypt.checksum.toHexString()
        let identityJsonKitString = String(format: "{\"data\":\"0x%@\",\"nation\":\"cn\",\"entity\":\"0\",\"fpr\":\"%@\",\"alg\":\"ECIES\",\"certtype\":\"1\",\"ver\":\"%@\",\"cdate\":\"\"}", encryptedDataStr, fpr, userDict["certtype"] as! String)
        return identityJsonKitString.toData()
    }
     // step-4: parameter----------issuer
    fileprivate func getIssuerData() -> Data {
        let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let KYCUserKey = "KYCUserInfo" + (accountInfo?.last!)!
        let userDict = UserDefaults.standard.value(forKey: KYCUserKey) as! [String: Any]
        let KYCUserCertStringKey = "KYCUserCertStringKey" + accountInfo!.last!
        let certString = UserDefaults.standard.value(forKey: KYCUserCertStringKey) as! String
        let escapeCertSring = certString.replacingOccurrences(of: "\n", with: "\\n")
        let currentAccount = kGetCurrentAccount()
        let autoIssuerJsonKitString = String(format: "{\"cert\":\"%@\",\"useid\":\"%@\",\"pubkey\":\"\",\"alg\":\"RSA\",\"cdate\":\"\",\"edate\":\"\",\"certtype\":\"%@\"}", escapeCertSring, currentAccount.address, userDict["certtype"] as! String)
        print(autoIssuerJsonKitString)
        return autoIssuerJsonKitString.toData()
    }
    //hash(aB)G
    fileprivate func encryptPubKey() -> String {
        let communityPubKey = SecureData(hexString: kCommunityPublicKeyStr)
        let currentAccount = kGetCurrentAccount()
        // hash(aB)
        let encryptPrivateKey = Account.point(fromPublic: communityPubKey?.data(), mainAccountPrivateKey: currentAccount.privateKey)
        let encryptPrivateKeySeparatedStrings = encryptPrivateKey!.description
        let array : Array = encryptPrivateKeySeparatedStrings.components(separatedBy: "=")
        let currentEncryptPrivateKeyString = (array.last! as NSString).substring(to: 66)
        print(currentEncryptPrivateKeyString)
        // hash(aB)G
        let encryptPubKey = Account.getPublicKey(withPrivateKey: currentEncryptPrivateKeyString.hexToBytes)
        let  encryptPubKeySeparatedStrings = encryptPubKey!.description
        let  pubArray : Array = encryptPubKeySeparatedStrings.components(separatedBy: "=")
        let  encryptPubKeyString = (pubArray.last! as NSString).substring(to: 132)
        return encryptPubKeyString
    }
    // fpr
    fileprivate func getHashUsrData() -> String {
        let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let KYCUserCerttypeIdAndDataHashKey = "KYCUserCerttypeIdAndDataHash" + accountInfo!.last!
        let hashUsrData = (UserDefaults.standard.value(forKey: KYCUserCerttypeIdAndDataHashKey) as! Array).last! as String
        return hashUsrData
    }
    
}
