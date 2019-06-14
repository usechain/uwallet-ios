//
//  USEMenmonicImportVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/18.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEMenmonicImportVC: USEWalletImportBaseVC {
    
    @objc  override func clickedBtn(btn: UIButton) {
            let mnemonicIndexpath = NSIndexPath(row: 0, section: 0)
            let mnemonicInputCell = tabView.cellForRow(at: mnemonicIndexpath as IndexPath) as! USEImportWalletInputCell
            let passcodeIndexpath = NSIndexPath(row: 1, section: 0)
            let passcodeInputCell = tabView.cellForRow(at: passcodeIndexpath as IndexPath) as! USEImportWalletPasscodeCell
            let repeatPasscodeIndexpath = NSIndexPath(row: 2, section: 0)
            let reaptPasscodeInputCell = tabView.cellForRow(at: repeatPasscodeIndexpath as IndexPath) as! USEImportWalletRepeatPasscodeCell
            if passcodeInputCell.passcodeLabel.text != reaptPasscodeInputCell.RepeatPasscodeLabel.text {
                showAlterView("两次密码不一致", mySelf: self)
                return
            }
            if passcodeInputCell.passcodeLabel.text!.isEmpty || reaptPasscodeInputCell.RepeatPasscodeLabel.text!.isEmpty  {
                showAlterView("密码不能为空", mySelf: self)
                return
            }
            if let account = UseEthersManager(mnemonicPhrase: mnemonicInputCell.inputTextView.text, slot: 0) {
                let tempAddress = account.address.data.toHexString()
                if kHasThisAddress(address: tempAddress) {
                    showAlterView("钱包已存在", mySelf: self)
                    return
                }
                if UserDefaults.standard.value(forKey: "USEUserWallets") != nil {
                    var walletsArray = UserDefaults.standard.value(forKey: "USEUserWallets") as! Array<String>
                    for i in walletsArray {
                        if mnemonicInputCell.inputTextView.text == i {
                            showAlterView("钱包已存在", mySelf: self)
                            return
                        }
                    }
                    walletsArray.append(mnemonicInputCell.inputTextView.text)
                    UserDefaults.standard .setValue(walletsArray, forKey: "USEUserWallets")
                } else {
                    var walletsArray = Array<String>()
                    walletsArray.append(mnemonicInputCell.inputTextView.text)
                    UserDefaults.standard .setValue(walletsArray, forKey: "USEUserWallets")
                }
                let passcodeStr = passcodeInputCell.passcodeLabel.text
                let mnmonicStr = mnemonicInputCell.inputTextView.text
                UserDefaults.standard.setValue(["MnemonicImportWallet", passcodeStr], forKey: mnmonicStr!)
                let currentAddress = account.address.data.toHexString()
                UserDefaults.standard.setValue(["MnemonicImportWallet", mnmonicStr, currentAddress.lowercased()], forKey: kUSECurrentAccountInfo)
                let currentPubKey = UseChainNetTools.getPubkeyWith(account: account)
                let  UmPublickKey = kUmPublickKeyHalf + currentAddress.lowercased()
                UserDefaults.standard.setValue(currentPubKey, forKey: UmPublickKey)
                UserDefaults.standard.synchronize()
                DispatchQueue.main.async {
                    account.encryptSecretStorageJSON(passcodeStr, callback: { (reuslt) in
                    })
                }
                self.navigationController?.pushViewController(USEWalletMainOldVC(), animated: true)
            } else {
                showAlterView("导入钱包失败", mySelf: self)
                return
            }
        }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
