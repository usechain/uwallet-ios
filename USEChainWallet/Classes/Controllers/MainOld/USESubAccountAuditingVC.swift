//
//  USESubAccountAuditingVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/5/13.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit
import HSCryptoKit
import BigInt

class USESubAccountAuditingVC: USEWalletBaseVC {
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
            self.encodeAbi()
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
        let account: Account = getCurrentAccountsParentAccount()
        print(account.address)
        self.navigationItem.title = "子账号上链认证"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    fileprivate lazy var walletInfo: Array = { () -> [String] in
        let currentWalletInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let parentAccontInfoHalfKey = "parentAccontInfoHalfKey"
        let parentWalletInfoKey = parentAccontInfoHalfKey + currentWalletInfo!.last!
        let parentAccontInfo = UserDefaults.standard.value(forKey: parentWalletInfoKey) as! Array<String>
        return parentAccontInfo
    }()

    fileprivate lazy var toDaChainBtn: UIButton = {
        let temp = UIButton(title: "一键子账号上链", fontSize: 18, color: UIColor.white, imageName: nil, backColor: UIColor.blue)
        temp.layer.cornerRadius = 30
        temp.tag = 2
        temp.addTarget(self, action: #selector(USESubAccountAuditingVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    var childAccountAddress: String?
    var generateChildAccountSlot: Int32 = {
        let currentChildAccountSlotHalfKey = "currentChildAccountSlotHalfKey"
        let currentWalletInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let currentChildAccountSlotKey = currentChildAccountSlotHalfKey + (currentWalletInfo?.last?.lowercased())!
        return UserDefaults.standard.value(forKey: currentChildAccountSlotKey) as! Int32
        
    }()
}

extension USESubAccountAuditingVC {
    fileprivate func setupUI() {
        self.view.addSubview(toDaChainBtn)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        toDaChainBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
    }
}

extension USESubAccountAuditingVC {
    // _pubkey 就是子账号的公钥
    // _encryptedAS
    // encryptPubKey 是hash(hB)G
    fileprivate func encryptedAS(mainAccountPubKey: String, randomAccountPubKey: String, encryptPubKey: String) -> Data {
        // step1: 传入 A - S 取A的前半段和S的后半段 组合成新的公钥
        print(mainAccountPubKey)
        print(randomAccountPubKey)
        let compressedAPubStr = getCompressedPubKey(pubkey: mainAccountPubKey as NSString)
        let compressedSPubStr = getCompressedPubKey(pubkey: randomAccountPubKey as NSString)
        print(compressedAPubStr)
        print(compressedSPubStr)
        let combinedTwoPubKey = compressedAPubStr + compressedSPubStr
        // setp2: 用用hash(hB)G加密给这个组合的公钥做ECIES加密
        print(encryptPubKey)
        let eciesEngine = ECIESEngine()
        // 截断communityPubKey的0x04
        let removePrefixEncryptPubKey = encryptPubKey.replacingOccurrences(of: "0x04", with: "")
        // 初始化message
        let message = combinedTwoPubKey
        let encryptPubKeyPoint = ECPoint(nodeId: Data(hex: removePrefixEncryptPubKey))
        let eciesEncrypt: ECIESEncryptedMessage = eciesEngine.encrypt(crypto: CryptoUtils.shared, randomHelper: RandomHelper.shared, remotePublicKey: encryptPubKeyPoint, message: message.toData())
        let encryptedDataStr = eciesEncrypt.ephemeralPublicKey.toHexString() + eciesEncrypt.initialVector.toHexString() + eciesEncrypt.cipher.toHexString() + eciesEncrypt.checksum.toHexString()
        let hadPrefixEncryptedDataStr = "0x" + encryptedDataStr
        return hadPrefixEncryptedDataStr.toData()
    }
    // contractAbi
    fileprivate func encodeAbi() {
        let types = [
            ABIv2.Element.InOut(name: "1", type: .dynamicBytes),
            ABIv2.Element.InOut(name: "2", type: .dynamicBytes),
            ABIv2.Element.InOut(name: "3", type: .bool),
        ]
        // H
        let pubKeyStr = getChildAccountPubKey()
        // _encryptedAS
        print(getRandomAccountPriKey())
        let data = ABIv2Encoder.encode(types: types, values: [pubKeyStr.toData(), encryptedAS(mainAccountPubKey: getCurrentWalletPubkey(), randomAccountPubKey: getRandomAccountPriKey(), encryptPubKey: getEncryptPubKey()), false] as [AnyObject])
        let addFunctionPrefixDataHexString = "0x0cc6705c" + (data?.toHexString())!
        // 发送交易
        toDaChain(abiCode: addFunctionPrefixDataHexString.hexToBytes!)
    }
    
    fileprivate func getChildAccountAddress() -> String {
        let childAccountPriKey = "0x" + getChildAccountPriKey()
        print(childAccountPriKey)
        let childAccount = Account(privateKey: childAccountPriKey.hexToBytes)
        childAccountAddress = "\(childAccount!.address!)"
        return childAccountAddress!
    }
    
    fileprivate func toDaChain(abiCode: Data) {
        
        
        let walletStore = getChildAccountPriKey()
        let correctPasscode = (UserDefaults.standard.value(forKey: walletStore) as! Array<String>).last
        let alertVC = UIAlertController(title: "请输入密码", message: "", preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        let confirmBtn = UIAlertAction(title: "确认", style: .destructive) { (action) in
            let textField = alertVC.textFields?.first
            if textField?.text == correctPasscode {
                self.view.showHUD(withText: "正在发送交易")
                let childAccount = Account(privateKey: walletStore.hexToBytes)
                
                UseChainNetTools.sendUSETransactionWith(account: childAccount!, gasLimite: "100000000", gasPrice: "1000000000", value: "0", toAddress: kF1ContractAddress, data: abiCode as NSData, flag: 0, resource: { (result, error) in
                    self.hideHUD()
                    if result != nil {
                        if (result as! [String: Any])["error"] != nil {
                            showAlterView("交易发送失败", mySelf: self)
                            return
                        }
                        UserDefaults.standard.setValue((result as! [String: Any])["result"], forKey: "currentTXHash")
                    } else {
                        showAlterView("转账失败", mySelf: self)
                        return
                    }
                    self.navigationController?.pushViewController(USETransferCompletedVC(), animated: true)
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
    
}
extension USESubAccountAuditingVC {
    
    fileprivate func getCompressedPubKey(pubkey: NSString) -> String {
        let removePrefixStr: NSString = pubkey.substring(from: 4) as NSString
        print(removePrefixStr)
        let xValue = removePrefixStr.substring(to: 64)
        print(xValue)
        let yValue = removePrefixStr.substring(from: 64)
        print(yValue)
        var prefix = ""
        let tempStr = "\(yValue.last!)"
        let tempInt = (UseEthersManager.numberHexString(tempStr)?.intValue)!
        if tempInt % 2 == 0 {
            // 偶数拼02
            prefix = "02"
        } else {
            // 奇数拼03
            prefix = "03"
        }
        let compressedPubKey = prefix + xValue
        return compressedPubKey
    }
    //hash(aB)
    fileprivate func halfEncryptPriKey() -> String {
        // 获取当前账户
        let communityPubKey = SecureData(hexString: kCommunityPublicKeyStr)
        let currentAccount = getCurrentAccountsParentAccount()
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
        let firstRandomAccount = Account(mnemonicPhrase: walletInfo[1], slot: generateChildAccountSlot)
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
        let firstRandomAccount = Account(mnemonicPhrase: walletInfo[1], slot: generateChildAccountSlot)
        // hash(aB) + s
        let prime = SecureData.init(hexString: kPrimeStr)
        let childAccountPriKey = Account.privateKeyAddMod(with: secureHalfEncryptPrivateKeyL.data(), andPrivateKey: firstRandomAccount?.privateKey, andPrime: prime?.data())
        return (childAccountPriKey?.hexString()?.dropHexPrefix)!
    }
    // hash(hB)G
    fileprivate func getEncryptPubKey() -> String {
        // 获取当前账户
        let communityPubKey = SecureData(hexString: kCommunityPublicKeyStr)
        let childAccountPriKey = "0x" + getChildAccountPriKey()
        // hash(hB)
        let encryptPrivateKey = Account.point(fromPublic: communityPubKey?.data(), mainAccountPrivateKey: childAccountPriKey.hexToBytes)
        // 字符串截取私钥
        let encryptPrivateKeySeparatedStrings = encryptPrivateKey!.description
        let array : Array = encryptPrivateKeySeparatedStrings.components(separatedBy: "=")
        let currentEncryptPrivateKeyString = (array.last! as NSString).substring(to: 66)
        // hash(hB)G
        let encryptedPubKey = Account.getPublicKey(withPrivateKey: currentEncryptPrivateKeyString.hexToBytes)
        let encryptedPubSeparatedStrings = encryptedPubKey!.description
        let encryptedPubArray : Array = encryptedPubSeparatedStrings.components(separatedBy: "=")
        let currentEncryptPubKeyString = (encryptedPubArray.last! as NSString).substring(to: 132)
        return currentEncryptPubKeyString
    }
    // (hash(aB) + s)G
    fileprivate func getChildAccountPubKey() -> String {
        let childAccountPriKey = "0x" + getChildAccountPriKey()
        print(Account.getPublicKey(withPrivateKey: childAccountPriKey.hexToBytes))
        let encryptPublicKey = Account.getPublicKey(withPrivateKey: childAccountPriKey.hexToBytes)
        // 字符串截取
        let encryptPublicKeySeparatedStrings = encryptPublicKey!.description
        let array : Array = encryptPublicKeySeparatedStrings.components(separatedBy: "=")
        let currentEncryptPublicKeyString = (array.last! as NSString).substring(to: 132)
        print(currentEncryptPublicKeyString)
        return currentEncryptPublicKeyString
    }
    // 主账号公钥
    fileprivate func getCurrentWalletPubkey() -> String {
        let currentAccount = getCurrentAccountsParentAccount()
        let currentPrivateKey: SecureData = SecureData(data: currentAccount.privateKey)
        print(currentPrivateKey.hexString())
        let currentPublicKey = Account.getPublicKey(withPrivateKey: currentAccount.privateKey)
        let separatedStrings = currentPublicKey!.description
        let array : Array = separatedStrings.components(separatedBy: "=")
        let currentPubKeyString = (array.last! as NSString).substring(to: 132)
        return currentPubKeyString
    }
 
    // 恢复子账号的主账号
    fileprivate func getCurrentAccountsParentAccount() -> Account {
        let currentWalletInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let parentAccontInfoHalfKey = "parentAccontInfoHalfKey"
        let parentWalletInfoKey = parentAccontInfoHalfKey + currentWalletInfo!.last!
        let parentAccontInfo = UserDefaults.standard.value(forKey: parentWalletInfoKey) as! Array<String>
        let walletStore = parentAccontInfo[1]
        let account: Account?
        if Account.isValidMnemonicPhrase(walletStore) {
            account = UseEthersManager(mnemonicPhrase: walletStore, slot: 0)
        } else {
            account = UseEthersManager(privateKey: walletStore.hexToBytes)
        }
        return account!
    }
    
}
