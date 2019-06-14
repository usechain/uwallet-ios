//
//  USEMineLaunageVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/30.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEMineNewContactorCellTableViewCellID = "USEMineNewContactorCellTableViewCellID"

enum ValidationError: Error {
    case invalidChecksum
    case invalidAddressLength
    case invalidSymbols
    case wrongAddressPrefix
}

class USEMineNewContactorVC: USEWalletBaseVC {
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
        let nameIP = NSIndexPath(row: 0, section: 0)
        let nameCell = mineTableView.cellForRow(at: nameIP as IndexPath) as! USEMineNewContactorCellTableViewCell
        let name = nameCell.inputFiled.text
        let descriptionIP = NSIndexPath(row: 1, section: 0)
        let descriptionCell = mineTableView.cellForRow(at: descriptionIP as IndexPath) as! USEMineNewContactorCellTableViewCell
        var description = descriptionCell.inputFiled.text
        let addressIP = NSIndexPath(row: 2, section: 0)
        let addressCell = mineTableView.cellForRow(at: addressIP as IndexPath) as! USEMineNewContactorCellTableViewCell
        let address = addressCell.inputFiled.text
        if name == "" || address == "" {
            showAlterView("必填字段不能为空", mySelf: self)
            return
        }
        if !USEAddressTools.isValidUSEAddress(address: address!) {
            showAlterView("不是合法的USE地址", mySelf: self)
            return
        }
        var array: Array<String> = []
        if description == "" {
            description = "nil"
        }
        array.append(name!)
        array.append(description!)
        array.append(address!)
        for array in UserDefaults.standard.value(forKey: "totalAddressBookInfo") as? [[Any]] ?? [] {
            if array.last as? String == address {
                showAlterView("该地址已经添加过", mySelf: self)
                return
            }
        }
        let wannaChangIndex = UserDefaults.standard.value(forKey: "wannaChangeIndex") as? Int
        if wannaChangIndex == 10000 {
            // Add
            var tempArray = UserDefaults.standard.value(forKey: "totalAddressBookInfo") as? [[Any]] ?? []
            tempArray.append(array)
            UserDefaults.standard.setValue(tempArray, forKey: "totalAddressBookInfo")
        } else {
            // Edit
             var tempArray = UserDefaults.standard.value(forKey: "totalAddressBookInfo") as? [[Any]] ?? []
            tempArray[wannaChangIndex!] = array
            UserDefaults.standard.setValue(tempArray, forKey: "totalAddressBookInfo")
        }
        UserDefaults.standard.setValue(10000, forKey: "wannaChangeIndex")
        self.navigationController?.popViewController(animated: true)
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
        perpareTableView()
        addEditTableviewSouce()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "新建联系人"
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: -Lazyloadkit
    fileprivate lazy var mineTableView: UITableView = UITableView()
    fileprivate lazy var tabTitleArray: Array = { () -> [String] in
        let temp = ["名称", "描述(选填)", "地址"]
        return temp
    }()
    fileprivate lazy var tabContentArray: Array = { () -> [String] in
        let temp = ["", "", ""]
        return temp
    }()
    var isAddressBookEditing: Bool = false
    fileprivate lazy var saveBtn: UIButton = {
        let temp = UIButton(title: "保存", fontSize: 18, color: UIColor.white, imageName: nil, backColor: UIColor(red: 40/255, green: 113/255, blue: 251/255, alpha: 1))
        temp.addTarget(self, action: #selector(USEMineNewContactorVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        temp.layer.cornerRadius = 10
        return temp
    }()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension USEMineNewContactorVC {
    
    fileprivate func setupUI() {
        self.view.addSubview(mineTableView)
        self.view.addSubview(saveBtn)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        mineTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(150)
        }
        saveBtn.snp.makeConstraints { (make) in
            make.top.equalTo(mineTableView.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
            make.height.equalTo(40)
            make.width.equalTo(160)
        }
    }
    
    fileprivate func addEditTableviewSouce() {
        let wannaChangIndex = UserDefaults.standard.value(forKey: "wannaChangeIndex") as? Int
        if wannaChangIndex == 10000 {
            isAddressBookEditing = false
        } else {
            var tempArray = UserDefaults.standard.value(forKey: "totalAddressBookInfo") as? [[Any]] ?? []
            let sourceArray = tempArray[wannaChangIndex!] as! [String]
           tabContentArray = sourceArray
            isAddressBookEditing = true
            mineTableView.reloadData()
        }
    }
}

extension USEMineNewContactorVC: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func perpareTableView() {
        mineTableView.delegate = self
        mineTableView.dataSource = self
        mineTableView.register(USEMineNewContactorCellTableViewCell.self, forCellReuseIdentifier: USEMineNewContactorCellTableViewCellID)
        mineTableView.tableFooterView = UIView()
        mineTableView.isScrollEnabled = false
        mineTableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: USEMineNewContactorCellTableViewCellID) as! USEMineNewContactorCellTableViewCell
        cell.inputFiled.placeholder = tabTitleArray[indexPath.row]
        if isAddressBookEditing {
            cell.inputFiled.text = tabContentArray[indexPath.row]
        }
        if indexPath.row == 2 {
            if let toAddress = UserDefaults.standard.value(forKey: "toAddressFromTransaction") as? String {
                if toAddress != "" {
                    cell.inputFiled.text = toAddress
                    UserDefaults.standard.setValue("", forKey: "toAddressFromTransaction")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
