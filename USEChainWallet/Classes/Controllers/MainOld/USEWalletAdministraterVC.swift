
//
//  USEWalletAdministraterVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/18.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEWalletAdministraterCellID = "USEWalletAdministraterCellID"

class USEWalletAdministraterVC: USEWalletBaseVC {

    @objc private func clickedBtn(btn: UIButton) {
        if btn.tag == 1 {
            self.navigationController?.pushViewController(USECreateWalletVC(), animated: true)
        } else {
            self.navigationController?.pushViewController(USEImportWalletVC(), animated: true)

        }
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
        prepareTableview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletNameArray = []
        walletAddressArray = []
        walletStoreArray = []
        self.navigationItem.title = "钱包管理"
        self.view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if selectedIndexPath != nil {
            tabView.scrollToRow(at: selectedIndexPath!, at: UITableView.ScrollPosition.bottom, animated: true)
        }
        // 遍历USEUserWallets
        let mnemonicArray = UserDefaults.standard.value(forKey: "USEUserWallets") as? Array<String>
        
        if mnemonicArray != nil {
            for i in mnemonicArray ?? Array() {
                let contentArray = UserDefaults.standard.value(forKey: i) as? Array<String>
                
                if contentArray != nil {
                    let walletNameDict = ["walletName": contentArray?.first]
                    let walletMnemonicDict = ["walletStore": i]
                    let tempAddress = UseEthersManager(mnemonicPhrase: i, slot: 0)?.address.data.toHexString()
                    let UMAddressPubKey = kUmPublickKeyHalf + (tempAddress?.lowercased())!
                    let umAddress = UseChainNetTools.getUMAddressWith(publicKey: UserDefaults.standard.value(forKey: UMAddressPubKey) as! NSString)
                    let walletAddressDict = ["walletAddress": umAddress]
                    
                    walletNameArray?.append(walletNameDict as! [String : String])
                    walletStoreArray?.append(walletMnemonicDict)
                    walletAddressArray?.append(walletAddressDict )
                }
            }
        }
        let privateKeyArray = UserDefaults.standard.value(forKey: "USEUserPrivateKeyWallets") as? Array<String>
        
        if privateKeyArray != nil {
            for i in privateKeyArray ?? Array() {
                let contentArray = UserDefaults.standard.value(forKey: i) as? Array<String>
                if contentArray != nil {
                    let walletNameDict = ["walletName": contentArray?.first]
                    let walletPrivateKey = ["walletStore": i]
                    let tempAddress = UseEthersManager(privateKey: i.hexToBytes)?.address.data.toHexString()
                    let UMAddressPubKey = kUmPublickKeyHalf + (tempAddress?.lowercased())!
                    let umAddress = UseChainNetTools.getUMAddressWith(publicKey: UserDefaults.standard.value(forKey: UMAddressPubKey) as! NSString)
                    let walletAddressDict = ["walletAddress": umAddress]
                    walletNameArray?.append(walletNameDict as! [String : String])
                    walletStoreArray?.append(walletPrivateKey)
                    walletAddressArray?.append(walletAddressDict as! [String : String])
                }
            }
        }
        tabView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        walletNameArray?.removeAll()
        walletStoreArray?.removeAll()
        walletAddressArray?.removeAll()
    }

    // MARK: -LazylaodKit
    var walletAddressArray: Array<Dictionary<String, String>>?
    var walletNameArray: Array<Dictionary<String, String>>?
    var walletStoreArray: Array<Dictionary<String, String>>?
    fileprivate lazy var tabView: UITableView = {
        let temp = UITableView()
        temp.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        return temp
    }()
    fileprivate lazy var createWalletBtn: UIButton = {
        let temp = UIButton(title: "创建钱包", fontSize: 16, color: UIColor.white, imageName: nil, backColor: UIColor(hexString: "3289fc"))
        temp.tag = 1
        temp.addTarget(self, action: #selector(USEWalletAdministraterVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    fileprivate lazy var importWalletBtn: UIButton = {
        let temp = UIButton(title: "导入钱包", fontSize: 16, color: UIColor.white, imageName: nil, backColor: UIColor(hexString: "093b74"))
        temp.tag = 2
        temp.addTarget(self, action: #selector(USEWalletAdministraterVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    fileprivate var selectedIndexPath: IndexPath?
}

extension USEWalletAdministraterVC {
    fileprivate func setupUI() {

        self.view.addSubview(tabView)
        self.view.addSubview(createWalletBtn)
        self.view.addSubview(importWalletBtn)
        
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        tabView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-50)
        }
        createWalletBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view)
            make.height.equalTo(50)
            make.left.equalTo(self.view)
            make.width.equalTo(UIScreen.main.bounds.size.width / 2)
        }
        importWalletBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view)
            make.height.equalTo(50)
            make.right.equalTo(self.view)
            make.width.equalTo(UIScreen.main.bounds.size.width / 2)
        }
    }
    fileprivate func prepareTableview() {
        tabView.delegate = self
        tabView.dataSource = self
        tabView.tableFooterView = UIView()
        tabView.register(USEWalletAdministraterCell.self, forCellReuseIdentifier: USEWalletAdministraterCellID)
        tabView.separatorStyle = .none
    }
}

extension USEWalletAdministraterVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletNameArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: USEWalletAdministraterCellID) as! USEWalletAdministraterCell
        cell.delegate = self
        if (walletNameArray?.count != 0 && walletStoreArray?.count != 0 && walletAddressArray?.count != 0) {
            cell.nameLabel.text = walletNameArray?[indexPath.row]["walletName"]
            cell.walletStore = (walletStoreArray?[indexPath.row]["walletStore"])!

            cell.addressLabel.text = (walletAddressArray?[indexPath.row]["walletAddress"])! as String
            cell.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
            // 如果是当前钱包 设置为选中状态
            let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
            
            let UMAddressPubKey = kUmPublickKeyHalf + (accountInfo?.last?.lowercased())!
            let umAddress = UseChainNetTools.getUMAddressWith(publicKey: UserDefaults.standard.value(forKey: UMAddressPubKey) as! NSString)
            
            if (walletAddressArray?[indexPath.row]["walletAddress"])! as String == umAddress {
                // 选中这个cell
                if selectedIndexPath == nil {
                    selectedIndexPath = indexPath
                    tabView.scrollToRow(at: selectedIndexPath!, at: UITableView.ScrollPosition.bottom, animated: true)
                }
                tabView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let classicAddress = UseChainNetTools.recoverToNormalAddress(umAddress: (walletAddressArray?[indexPath.row]["walletAddress"])!).dropHexPrefix

        UserDefaults.standard.setValue([walletNameArray?[indexPath.row]["walletName"], walletStoreArray?[indexPath.row]["walletStore"], classicAddress], forKey: kUSECurrentAccountInfo)
    }
}

extension USEWalletAdministraterVC:USEWalletAdministraterCellBtnClicked {
    func clicked(btn: UIButton) {
                self.navigationController?.pushViewController(USEWalletDetailVC(), animated: true)
    }
}
