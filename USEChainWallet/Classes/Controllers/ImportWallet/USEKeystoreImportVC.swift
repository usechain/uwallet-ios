//
//  USEKeystoreImportVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/18.
//  Copyright © 2019 Jacob. All rights reserved.
//
import UIKit

class USEKeystoreImportVC: USEWalletImportBaseVC {
    
    @objc override func clickedBtn(btn: UIButton) {
            let keystoreIndexpath = NSIndexPath(row: 0, section: 0)
            let keystoreInputCell = tabView.cellForRow(at: keystoreIndexpath as IndexPath) as! USEImportWalletInputCell
            let passcodeIndexpath = NSIndexPath(row: 1, section: 0)
            let passcodeInputCell = tabView.cellForRow(at: passcodeIndexpath as IndexPath) as! USEImportWalletPasscodeCell
            let repeatPasscodeIndexpath = NSIndexPath(row: 2, section: 0)
            let reaptPasscodeInputCell = tabView.cellForRow(at: repeatPasscodeIndexpath as IndexPath) as! USEImportWalletRepeatPasscodeCell
            if passcodeInputCell.passcodeLabel.text != reaptPasscodeInputCell.RepeatPasscodeLabel.text {
                showAlterView("两次密码不一致", mySelf: self)
                return
            }
            if passcodeInputCell.passcodeLabel.text == "" || reaptPasscodeInputCell.RepeatPasscodeLabel.text == "" {
                showAlterView("密码不能为空", mySelf: self)
                return
            }
            //keystore导入
            self.showHUD(withText: "努力导入中...")

        UseEthersManager.decryptSecretStorageJSON(keystoreInputCell.inputTextView.text, password: passcodeInputCell.passcodeLabel.text) { (account, error) in
                if account == nil {
                    showAlterView("导入钱包失败", mySelf: self)
                    self.hideHUD()
                    return
                } else {
                    let tempAddress = account?.address.data.toHexString()
                    if kHasThisAddress(address: tempAddress!) {
                        showAlterView("钱包已存在", mySelf: self)
                        return
                    }
                    if UserDefaults.standard.value(forKey: "USEUserPrivateKeyWallets") != nil {
                        var walletsArray = UserDefaults.standard.value(forKey: "USEUserPrivateKeyWallets") as! Array<String>
                        for i in walletsArray {
                            if account?.privateKey.toHexString() == i {
                                showAlterView("钱包已存在", mySelf: self)
                                self.hideHUD()
                                return
                            }
                        }
                        walletsArray.append(account?.privateKey.toHexString() ?? "")
                        UserDefaults.standard .setValue(walletsArray, forKey: "USEUserPrivateKeyWallets")
                    } else {
                        var walletsArray = Array<String>()
                        walletsArray.append(account?.privateKey.toHexString() ?? "")
                        UserDefaults.standard .setValue(walletsArray, forKey: "USEUserPrivateKeyWallets")
                    }
                    let tempPasscode = passcodeInputCell.passcodeLabel.text
                    let tempPrivate = account?.privateKey.toHexString() ?? ""
                    UserDefaults.standard.setValue(["KeystoreKeyImportWallet", tempPasscode], forKey: tempPrivate)
                    let currentAddress = account?.address.data.toHexString()
                    UserDefaults.standard.setValue(["KeystoreKeyImportWallet", tempPrivate, currentAddress], forKey: kUSECurrentAccountInfo)
                    // 存公钥
                    let currentPubKey = UseChainNetTools.getPubkeyWith(account: account!)
                    let  UmPublickKey = kUmPublickKeyHalf + currentAddress!
                    UserDefaults.standard.setValue(currentPubKey, forKey: UmPublickKey)
                   self.hideHUD()
                    self.navigationController?.pushViewController(USEWalletMainOldVC(), animated: true)
                }
            }
        }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension USEKeystoreImportVC {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.item == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: USEImportInputCellID) as! USEImportWalletInputCell
                cell.topLabel.text = "请输入keyStore内容至输入框。"
                cell.placeHolder.text = "请输入您的keyStore"
                return cell
            } else if indexPath.item == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: USEImportPasscodeCellID) as! USEImportWalletPasscodeCell
                return cell
            } else if indexPath.item == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: USEImportRepeatPasscodeCellID) as! USEImportWalletRepeatPasscodeCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: USEImportPasscodeAttentionCellID) as! USEImportWalletPasscodeAttentionCell
                return cell
            }
        }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.item == 0 {
                return 195
            } else {
                return 60
            }
        }
}
