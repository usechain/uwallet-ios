//
//  USETransferToAddressListVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/4/18.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEAddressBookCellID = "USEAddressBookCellID"

class USETransferToAddressListVC: USEWalletBaseVC {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tabTitleArray = []
        self.tabTitleArray = UserDefaults.standard.value(forKey: "totalAddressBookInfo") as? [[Any]] ?? []
        self.mineTableView.reloadData()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
        perpareTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "地址簿"
        self.view.backgroundColor = UIColor.white

    }
    
    fileprivate lazy var mineTableView: UITableView = UITableView()
    fileprivate lazy var tabTitleArray: Array = { () -> [Array<Any>] in
        let temp = [[]]
        return temp
    }()
    
}

extension USETransferToAddressListVC {
    
    fileprivate func setupUI() {
        self.view.addSubview(mineTableView)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }

        mineTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
}

extension USETransferToAddressListVC: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func perpareTableView() {
        mineTableView.delegate = self
        mineTableView.dataSource = self
        mineTableView.register(USEAddressBookCell.self, forCellReuseIdentifier: USEAddressBookCellID)
        mineTableView.tableFooterView = UIView()
        mineTableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabTitleArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: USEAddressBookCellID) as! USEAddressBookCell
        if tabTitleArray.count != 0 {
            cell.topLabel.text = tabTitleArray[indexPath.row][0] as! String + "   (" + (tabTitleArray[indexPath.row][1] as! String) + ")"
            cell.addressLabel.text = tabTitleArray[indexPath.row][2] as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addressBookCell = mineTableView.cellForRow(at: indexPath as IndexPath) as! USEAddressBookCell
        let selectedAddress = addressBookCell.addressLabel.text
        UserDefaults.standard.setValue(selectedAddress, forKey: "toAddressFromAddressBook")
        self.navigationController?.popViewController(animated: true)
    }
    
}
