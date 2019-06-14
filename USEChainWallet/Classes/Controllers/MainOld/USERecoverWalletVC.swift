//
//  USERecoverWalletVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/6/5.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USERecoverWalletCellID = "USERecoverWalletCellID"
private let USEKYCConfirmBtnCellID = "USEKYCConfirmBtnCellID"

class USERecoverWalletVC: USEWalletBaseVC {
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
        let selectedCellIP = NSIndexPath(row: selectedBtn.tag, section: 0)
        let selectedCell = tabView.cellForRow(at: selectedCellIP as IndexPath) as! USERecoverWalletCell
        let walletStore = selectedCell.walletStore!
        
        let correctPasscode = (UserDefaults.standard.value(forKey: walletStore) as! Array<String>).last
        let alertVC = UIAlertController(title: "请输入密码", message: "", preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel) { (action) in
            print("取消")
        }
        let confirmBtn = UIAlertAction(title: "确认", style: .destructive) { (action) in
            print("确认")
            let textField = alertVC.textFields?.first
            if textField?.text == correctPasscode {
                if btn.tag == USERecoverWalletVCBtnTag.recoverConfirmed.rawValue {
                    if Account.isValidMnemonicPhrase(walletStore) {
                        self.recoverWalletWith(type: kUserMnemonicKeyWalletsKey, walletStore: walletStore)
                    } else {
                        self.recoverWalletWith(type: kUserPrivateKeyWalletsKey, walletStore: walletStore)
                    }
                }
                self.removeRecoverUD(walletStore: walletStore)
                self.prepareSourceArrayAndReload()
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
    
    override func loadView() {
        super.loadView()
        setupUI()
        prepareTableview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "恢复账号"
        self.view.backgroundColor = UIColor.white
        walletNameArray = []
        walletAddressArray = []
        walletStoreArray = []
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        prepareSourceArrayAndReload()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        walletNameArray?.removeAll()
        walletAddressArray?.removeAll()
        walletStoreArray?.removeAll()
    }
    fileprivate lazy var tabView: UITableView  = UITableView()
    fileprivate lazy var selectedBtn: UIButton = UIButton()
    fileprivate lazy var walletInfo: Array = { () -> [String] in
        let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        return useCurrentAccountArray ?? []
    }()

    var walletAddressArray: Array<Dictionary<String, String>>?
    var walletNameArray: Array<Dictionary<String, String>>?
    var walletStoreArray: Array<Dictionary<String, String>>?
}

extension USERecoverWalletVC {
    fileprivate func setupUI() {
        self.view.addSubview(tabView)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        tabView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    fileprivate func prepareTableview() {
        tabView.delegate = self
        tabView.dataSource  = self
        tabView.tableFooterView = UIView()
        tabView.separatorStyle = .none

        tabView.register(USERecoverWalletCell.self, forCellReuseIdentifier: USERecoverWalletCellID)
        tabView.register(USEKYCConfirmBtnCell.self, forCellReuseIdentifier: USEKYCConfirmBtnCellID)
    }
}

extension USERecoverWalletVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if walletNameArray?.count != nil {
            return walletNameArray!.count + 2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < walletNameArray!.count {
                        let cell = tableView.dequeueReusableCell(withIdentifier: USERecoverWalletCellID) as! USERecoverWalletCell
                        cell.leftBtn.tag = indexPath.row
                        cell.leftBtn.isSelected = false
                        cell.delegate = self
                        if indexPath.row == 0 {
                            self.selectedBtn = cell.leftBtn
                            cell.leftBtn.isSelected = true
                        }
            cell.rightWalletNameLable.text = walletNameArray![indexPath.row]["walletName"]
            let ellipseAddressStr = (walletAddressArray![indexPath.row]["walletAddress"])?.ellipsisMiddleSting
            cell.rightAddressLabel.text = ellipseAddressStr
            cell.walletStore = walletStoreArray![indexPath.row]["walletStore"]
                return cell
           
        } else if indexPath.row == walletNameArray!.count {
                        let cell = UITableViewCell()
                        cell.selectionStyle = .none
                        let btn = UIButton(title: "确认恢复", fontSize: 20, color: UIColor.white, imageName: nil, backColor: UIColor(red: 40/255, green: 113/255, blue: 251/255, alpha: 1.0))
                        cell.contentView.addSubview(btn)
                        btn.snp.makeConstraints { (make) in
                            make.center.equalTo(cell.contentView)
                            make.width.equalTo(200)
                        }
                        btn.layer.cornerRadius = 20
                        btn.addTarget(self, action: #selector(USERecoverWalletVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
            btn.tag = USERecoverWalletVCBtnTag.recoverConfirmed.rawValue
                        return cell
        } else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            let btn = UIButton(title: "彻底删除", fontSize: 20, color: UIColor.white, imageName: nil, backColor: UIColor(red: 40/255, green: 113/255, blue: 251/255, alpha: 1.0))
            cell.contentView.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.center.equalTo(cell.contentView)
                make.width.equalTo(200)
            }
            btn.layer.cornerRadius = 20
            btn.addTarget(self, action: #selector(USERecoverWalletVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
            btn.tag = USERecoverWalletVCBtnTag.removeForever.rawValue
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 80
    }
}

extension USERecoverWalletVC:USERecoverWalletCellBtnClicked {
    func clicked(btn: UIButton) {
        self.selectedBtn.isSelected = false
        btn.isSelected = true
        self.selectedBtn = btn
    }
}

extension USERecoverWalletVC {
    fileprivate func prepareSourceArrayAndReload() {
        let storeArray = UserDefaults.standard.value(forKey: kRecoverWalletsKey) as? Array<String>
        walletNameArray = []
        walletStoreArray = []
        walletAddressArray = []
        for i in storeArray! {
            let contentArray = UserDefaults.standard.value(forKey: i) as? Array<String>
            let walletNameDict = ["walletName": contentArray?.first]
            var tempAddress = ""
            if Account.isValidMnemonicPhrase(i) {
                tempAddress = (UseEthersManager(mnemonicPhrase: i, slot: 0)?.address.data.toHexString())!
            } else {
                tempAddress = (UseEthersManager(privateKey: i.hexToBytes)?.address.data.toHexString())!
            }
            let UMAddressPubKey = kUmPublickKeyHalf + (tempAddress.lowercased())
            let umAddress = UseChainNetTools.getUMAddressWith(publicKey: UserDefaults.standard.value(forKey: UMAddressPubKey) as! NSString)
            let walletAddressDict = ["walletAddress": umAddress]
            walletNameArray?.append(walletNameDict as! [String : String])
            walletAddressArray?.append(walletAddressDict )
            let walletStoreDict = ["walletStore": i]
            walletStoreArray?.append(walletStoreDict)
        }
        tabView.reloadData()
    }
    
    fileprivate func recoverWalletWith(type: String, walletStore: String) {
        if UserDefaults.standard.value(forKey: type) != nil {
            var walletsArray = UserDefaults.standard.value(forKey: type) as! Array<String>
            for i in walletsArray {
                if walletStore == i {
                    showAlterView("钱包已存在", mySelf: self)
                    return
                }
            }
            walletsArray.append(walletStore)
            UserDefaults.standard .setValue(walletsArray, forKey: type)
        } else {
            var walletsArray = Array<String>()
            walletsArray.append(walletStore)
            UserDefaults.standard .setValue(walletsArray, forKey: type)
        }
    }
    
    fileprivate func removeRecoverUD(walletStore: String) {
        let recoverArray = UserDefaults.standard.value(forKey: kRecoverWalletsKey) as! Array<String>
        var othersArray: Array<String> = []
        for i in recoverArray {
            if i == walletStore {
                continue
            }
            othersArray.append(i)
        }
        UserDefaults.standard.setValue(othersArray, forKey: kRecoverWalletsKey)
    }
}
