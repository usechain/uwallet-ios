//
//  USEGenerateSubAccountVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/5/13.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit
import HSCryptoKit
import BigInt

class USEGenerateSubAccountVC: USEWalletBaseVC {
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
        
//        if btn.tag == 2 {
//            showAlterView("待讨论", mySelf: self)
//            return
//        }
        
        if !isMnmonicParentAccount! {
            showAlterView("私钥导入或子账号无法生成子账号", mySelf: self)
            return
        }
        
                let alertVC = UIAlertController(title: "请设置子账户密码", message: "", preferredStyle: .alert)
                let cancelBtn = UIAlertAction(title: "取消", style: .cancel) { (action) in
                    print("取消")
                    return
                }
                let confirmBtn = UIAlertAction(title: "确认", style: .destructive) { (action) in
                    print("确认")
                    let textField = alertVC.textFields?.first
                    let childAccountSlot = "childAccountSlot"
                    let childAccountSlotKey = childAccountSlot + self.walletInfo.last!
                    print(childAccountSlotKey)
                    if UserDefaults.standard.value(forKey: childAccountSlotKey) != nil {
                        let currentChildAccountSlot = UserDefaults.standard.value(forKey: childAccountSlotKey) as! Int
                        let nextChildAccountSlot = currentChildAccountSlot + 1
                        UserDefaults.standard.setValue(nextChildAccountSlot, forKey: childAccountSlotKey);
                    } else {
                        UserDefaults.standard.setValue(1, forKey: childAccountSlotKey);
                    }
                    self.generateChildAccountSlot = (UserDefaults.standard.value(forKey: childAccountSlotKey)! as! Int32)
                    let childAccountPriKey = self.getChildAccountPriKey()
                    if UserDefaults.standard.value(forKey: "USEUserPrivateKeyWallets") != nil {
                        var walletsArray = UserDefaults.standard.value(forKey: "USEUserPrivateKeyWallets") as! Array<String>
                        for i in walletsArray {
                            if childAccountPriKey == i {
                                showAlterView("钱包已存在", mySelf: self)
                            }
                        }
                        walletsArray.append(childAccountPriKey)
                        UserDefaults.standard .setValue(walletsArray, forKey: "USEUserPrivateKeyWallets")
                    } else {
                        var walletsArray = Array<String>()
                        walletsArray.append(childAccountPriKey)
                        UserDefaults.standard .setValue(walletsArray, forKey: "USEUserPrivateKeyWallets")
                    }
                    let childAccountAddress = self.getChildAccountAddress().dropHexPrefix
                    print(childAccountAddress)
                    let account: Account = UseEthersManager(privateKey: childAccountPriKey.hexToBytes)
                    let currentPubKey = UseChainNetTools.getPubkeyWith(account: account)
                    let  UmPublickKey = kUmPublickKeyHalf + childAccountAddress.lowercased()
                    UserDefaults.standard.setValue(currentPubKey, forKey: UmPublickKey)
                    let mainAccountInfoArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo)
                    let parentAccontInfoHalfKey = "parentAccontInfoHalfKey"
                    let parentAccontInfoKey = parentAccontInfoHalfKey + childAccountAddress.lowercased()   
                    UserDefaults.standard.setValue(mainAccountInfoArray, forKey: parentAccontInfoKey)
                    let tempPasscode = textField?.text
                    let tempPrivate = childAccountPriKey
                    let childAccountName: String = "child" + "\(self.generateChildAccountSlot!)" + "of" + "\(self.walletInfo[0])"
                    let currentChildAccountSlotHalfKey = "currentChildAccountSlotHalfKey"
                    let currentChildAccountSlotKey = currentChildAccountSlotHalfKey + childAccountAddress.lowercased()
            
                    UserDefaults.standard.setValue(self.generateChildAccountSlot!, forKey: currentChildAccountSlotKey)

                    UserDefaults.standard.setValue([childAccountName, tempPasscode], forKey: tempPrivate)

                    UserDefaults.standard.setValue([childAccountName, childAccountPriKey, childAccountAddress], forKey: kUSECurrentAccountInfo)
                    
                    DispatchQueue.main.async {
                        account.encryptSecretStorageJSON(tempPasscode, callback: { (reuslt) in
                        })
                    }
                    
                    for controller in (self.navigationController?.viewControllers)! {
                        if controller.isKind(of: USEWalletMainOldVC.self) {
                            self.navigationController?.popToViewController(controller, animated: true)
                            return
                        }
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
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        childAccountAddress = ""
        print(walletInfo[1])
        self.navigationItem.title = "生成子账号"
        let firstRandomAccount = Account(mnemonicPhrase: walletInfo[1], slot: 0)
        if firstRandomAccount == nil {
            showAlterView("私钥导入或子账号无法生成子账号", mySelf: self)
            isMnmonicParentAccount = false
            return
        }
        isMnmonicParentAccount = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    fileprivate lazy var walletInfo: Array = { () -> [String] in
        let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        return useCurrentAccountArray ?? []
    }()
    fileprivate lazy var generateChildAccount: UIButton = {
        let temp = UIButton(title: "生成子账号", fontSize: 18, color: UIColor.white, imageName: nil, backColor: UIColor.blue)
        temp.layer.cornerRadius = 30
        temp.tag = 1
        temp.addTarget(self, action: #selector(USEGenerateSubAccountVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
//    fileprivate  lazy var recoverSubAccount: UIButton =  {
//        let temp = UIButton(title: "恢复子账号", fontSize: 18, color: UIColor.white, imageName: nil, backColor: UIColor.blue)
//        temp.layer.cornerRadius = 30
//        temp.tag = 2
//        temp.addTarget(self, action: #selector(USEGenerateSubAccountVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
//        return temp
//    }()
    
    var childAccountAddress: String?
    var generateChildAccountSlot: Int32?
    var isMnmonicParentAccount: Bool?
}

extension USEGenerateSubAccountVC {
    fileprivate func setupUI() {
        self.view.addSubview(generateChildAccount)
//        self.view.addSubview(recoverSubAccount)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        generateChildAccount.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
//        recoverSubAccount.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self.view)
//            make.top.equalTo(generateChildAccount.snp.bottom).offset(30)
//            make.width.equalTo(200)
//            make.height.equalTo(60)
//        }
    }
}

extension USEGenerateSubAccountVC {
    
    // 临时取子账号地址
    fileprivate func getChildAccountAddress() -> String {
        let childAccountPriKey = "0x" + getChildAccountPriKey()
        print(childAccountPriKey)
        let childAccount = Account(privateKey: childAccountPriKey.hexToBytes)
        childAccountAddress = "\(childAccount!.address!)"
        return childAccountAddress!
    }
}
extension USEGenerateSubAccountVC {
    //hash(aB)
    fileprivate func halfEncryptPriKey() -> String {
        let communityPubKey = SecureData(hexString: kCommunityPublicKeyStr)
        let currentAccount = kGetCurrentAccount()
        // hash(aB)
        let encryptPrivateKey = Account.point(fromPublic: communityPubKey?.data(), mainAccountPrivateKey: currentAccount.privateKey)
        // 字符串截取私钥
        let encryptPrivateKeySeparatedStrings = encryptPrivateKey!.description
        let array : Array = encryptPrivateKeySeparatedStrings.components(separatedBy: "=")
        let currentEncryptPrivateKeyString = (array.last! as NSString).substring(to: 66)
        print(currentEncryptPrivateKeyString)
        return currentEncryptPrivateKeyString
    }
    // S 随机账户公钥
    fileprivate func getRandomAccountPriKey() -> String {
        let firstRandomAccount = Account(mnemonicPhrase: walletInfo[1], slot: generateChildAccountSlot!)
        let firstRandomPrivateKey: SecureData = SecureData(data: firstRandomAccount?.privateKey)
        print(firstRandomPrivateKey.hexString())
        let firstRandomPublicKey = Account.getPublicKey(withPrivateKey: firstRandomAccount?.privateKey)
        let separatedStrings = firstRandomPublicKey!.description
        let array : Array = separatedStrings.components(separatedBy: "=")
        let firstRandomPublicKeyString = (array.last! as NSString).substring(to: 132)
        return firstRandomPublicKeyString
    }
    // hash(aB) + s--------------->h
    fileprivate func getChildAccountPriKey() -> String {
        // hash(aB) ----- str
        let halfEncryptPrivateKey = halfEncryptPriKey()
        let secureHalfEncryptPrivateKeyL: SecureData = SecureData(hexString: halfEncryptPrivateKey)
        // (s,S)
        // 如果walletInfo[1]的是私钥 提示用户不能生成子账户
        let firstRandomAccount = Account(mnemonicPhrase: walletInfo[1], slot: generateChildAccountSlot!)
        // hash(aB) + s
                let prime = SecureData.init(hexString: kPrimeStr)
        let childAccountPriKey = Account.privateKeyAddMod(with: secureHalfEncryptPrivateKeyL.data(), andPrivateKey: firstRandomAccount?.privateKey, andPrime: prime?.data())
        return (childAccountPriKey?.hexString()?.dropHexPrefix)!
    }
   
    // 主账号公钥
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
}
