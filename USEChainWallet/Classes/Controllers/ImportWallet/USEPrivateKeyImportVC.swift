//
//  USEPrivateKeyImportVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/18.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEPrivateKeyImportVC: USEWalletImportBaseVC {

    @objc  override func clickedBtn(btn: UIButton) {
            let privateKeyIndexpath = NSIndexPath(row: 0, section: 0)
            let privateKeyInputCell = tabView.cellForRow(at: privateKeyIndexpath as IndexPath) as! USEImportWalletInputCell
            let passcodeIndexpath = NSIndexPath(row: 1, section: 0)
            let passcodeInputCell = tabView.cellForRow(at: passcodeIndexpath as IndexPath) as! USEImportWalletPasscodeCell
            let repeatPasscodeIndexpath = NSIndexPath(row: 2, section: 0)
            let reaptPasscodeInputCell = tabView.cellForRow(at: repeatPasscodeIndexpath as IndexPath) as! USEImportWalletRepeatPasscodeCell
            if passcodeInputCell.passcodeLabel.text != reaptPasscodeInputCell.RepeatPasscodeLabel.text {
                showAlterView("两次密码不一致", mySelf: self)
                return
            }
            if passcodeInputCell.passcodeLabel.text!.isEmpty || reaptPasscodeInputCell.RepeatPasscodeLabel.text!.isEmpty {
                showAlterView("密码不能为空", mySelf: self)
                return
            }
            if let account = UseEthersManager(privateKey: privateKeyInputCell.inputTextView.text.hexToBytes) {
                let tempAddress = account.address.data.toHexString()
                if kHasThisAddress(address: tempAddress) {
                    showAlterView("钱包已存在", mySelf: self)
                    return
                }
                if UserDefaults.standard.value(forKey: "USEUserPrivateKeyWallets") != nil {
                    var walletsArray = UserDefaults.standard.value(forKey: "USEUserPrivateKeyWallets") as! Array<String>
                    for i in walletsArray {
                        if privateKeyInputCell.inputTextView.text.dropHexPrefix == i {
                            showAlterView("钱包已存在", mySelf: self)
                            return
                        }
                    }
                    walletsArray.append(privateKeyInputCell.inputTextView.text.dropHexPrefix)
                    UserDefaults.standard .setValue(walletsArray, forKey: "USEUserPrivateKeyWallets")
                } else {
                    var walletsArray = Array<String>()
                    walletsArray.append(privateKeyInputCell.inputTextView.text.dropHexPrefix)
                    UserDefaults.standard .setValue(walletsArray, forKey: "USEUserPrivateKeyWallets")
                }
                let tempPasscode = passcodeInputCell.passcodeLabel.text
                let tempPrivate = privateKeyInputCell.inputTextView.text.dropHexPrefix
                UserDefaults.standard.setValue(["PrivateKeyImportWallet", tempPasscode], forKey: tempPrivate)
                let currentAddress = account.address.data.toHexString()
                let privateKeyStr = privateKeyInputCell.inputTextView.text.dropHexPrefix
                UserDefaults.standard.setValue(["PrivateKeyImportWallet", privateKeyStr, currentAddress.lowercased()], forKey: kUSECurrentAccountInfo)
                let currentPubKey = UseChainNetTools.getPubkeyWith(account: account)
                let  UmPublickKey = kUmPublickKeyHalf + (currentAddress.lowercased())
                UserDefaults.standard.setValue(currentPubKey, forKey: UmPublickKey)
                DispatchQueue.main.async {
                    account.encryptSecretStorageJSON(tempPasscode, callback: { (reuslt) in
                    })
                }
               self.navigationController?.pushViewController(USEWalletMainOldVC(), animated: true)
            } else {
                showAlterView("导入失败", mySelf: self)
                return
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

extension USEPrivateKeyImportVC {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.item == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: USEImportInputCellID) as! USEImportWalletInputCell
                cell.topLabel.text = "输入Private Key文件内容至输入框。或通过扫描Private Key内容生成的二维码录入。请留意字符大小写。"
                if let scanPK = UserDefaults.standard.value(forKey: "scanPrivateKeyStr") {
                    cell.inputTextView.text = scanPK as? String
                    if scanPK as! String == "" {
                        cell.placeHolder.isHidden = false
                    } else {
                        cell.placeHolder.isHidden = true
                    }

                    UserDefaults.standard.setValue("", forKey: "scanPrivateKeyStr")
                }
                cell.placeHolder.text = "请输入明文私钥"
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
                return 210
            } else {
                return 60
            }
        }
}
