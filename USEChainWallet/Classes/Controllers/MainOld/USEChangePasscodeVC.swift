//
//  USEChangePasscodeVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/22.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEWalletChangePasscodeInputCellID = "USEWalletChangePasscodeInputCellID"

class USEChangePasscodeVC: USEWalletBaseVC {
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
        let oldPasscodeIP = NSIndexPath(row: 0, section: 0)
        let oldPasscodeCell = tabView.cellForRow(at: oldPasscodeIP as IndexPath) as! USEWalletChangePasscodeInputCell
        let oldPassCodeText = oldPasscodeCell.inputFiled.text
        let newPasscodeIP = NSIndexPath(row: 1, section: 0)
        let newPasscodeCell = tabView.cellForRow(at: newPasscodeIP as IndexPath) as! USEWalletChangePasscodeInputCell
        let newPassCodeText = newPasscodeCell.inputFiled.text
        let oconfirmPasscodeIP = NSIndexPath(row: 2, section: 0)
        let confirmPasscodeCell = tabView.cellForRow(at: oconfirmPasscodeIP as IndexPath) as! USEWalletChangePasscodeInputCell
         let confirmPassCodeText = confirmPasscodeCell.inputFiled.text
        let walletStore = walletInfo[1]
        let correctPasscode = (UserDefaults.standard.value(forKey: walletStore) as! Array<String>).last
        if oldPassCodeText == correctPasscode {
            if newPassCodeText == confirmPassCodeText {
                if oldPassCodeText == newPassCodeText {
                    showAlert("原密码不能和新密码相同")
                    return
                }
                let currentWalletName = (UserDefaults.standard.value(forKey: walletStore) as! Array<String>).first
                let tempArray = [currentWalletName, newPassCodeText]
                UserDefaults.standard.setValue(tempArray, forKey: walletStore)
                showAlterView("修改密码成功", mySelf: self)
                let time: TimeInterval = 1.0
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                showAlterView("两次输入的新密码不一致", mySelf: self)
            }
        } else {
            showAlterView("密码错误", mySelf: self)
        }
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        self.navigationItem.title = "修改密码"
    }
    
    fileprivate lazy var walletInfo: Array = { () -> [String] in
        let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        return useCurrentAccountArray ?? []
    }()
    
    fileprivate lazy var tabView: UITableView = {
        let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView()
        temp.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        temp.register(USEWalletChangePasscodeInputCell.self, forCellReuseIdentifier: USEWalletChangePasscodeInputCellID)
        temp.isScrollEnabled = false
        return temp
    }()
    
    fileprivate lazy var saveBtn: UIButton = {
        let temp = UIButton(title: "保存", fontSize: 18, color: UIColor.white, imageName: nil, backColor: UIColor(red: 43/255, green: 126/255, blue: 251/255, alpha: 1.0))
        temp.addTarget(self, action: #selector(USEChangePasscodeVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        temp.layer.cornerRadius = 25
        return temp
    }()
    
}

extension USEChangePasscodeVC {
    
    fileprivate func setupUI() {
        self.view.addSubview(tabView)
        self.view.addSubview(saveBtn)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        tabView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(180)
        }
        saveBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(tabView.snp.bottom).offset(30)
            make.width.equalTo(UIScreen.main.bounds.size.width * 0.9)
            make.height.equalTo(50)
        }
    }
    
}

extension USEChangePasscodeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: USEWalletChangePasscodeInputCellID) as! USEWalletChangePasscodeInputCell
        let placeHolderArray = ["原密码", "新密码", "重复新密码"]
        cell.inputFiled.placeholder = placeHolderArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
    }
    
}
