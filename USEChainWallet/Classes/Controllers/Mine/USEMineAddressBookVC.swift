//
//  USEMineAddressBookVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/30.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEAddressBookCellID = "USEAddressBookCellID"

class USEMineAddressBookVC: USEWalletBaseVC {
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
        self.navigationController?.pushViewController(USEMineNewContactorVC(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        UserDefaults.standard.setValue(10000, forKey: "wannaChangeIndex")
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "jiaru"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(USEMineAddressBookVC.clickedBtn(btn:)))
    }
    
    //MARK: -Lazyloadkit
    fileprivate lazy var mineTableView: UITableView = UITableView()
    fileprivate lazy var tabTitleArray: Array = { () -> [Array<Any>] in
        let temp = [[]]
        return temp
    }()
    
}

extension USEMineAddressBookVC {
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

extension USEMineAddressBookVC: UITableViewDelegate, UITableViewDataSource {
    
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
            //赋值
            cell.topLabel.text = tabTitleArray[indexPath.row][0] as! String + "   (" + (tabTitleArray[indexPath.row][1] as! String) + ")"
            cell.addressLabel.text = tabTitleArray[indexPath.row][2] as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "编辑") {
            action, index in
            
            UserDefaults.standard.setValue(indexPath.row, forKey: "wannaChangeIndex")
            self.navigationController?.pushViewController(USEMineNewContactorVC(), animated: true)
        }
        edit.backgroundColor = UIColor.orange
        let delete = UITableViewRowAction(style: .normal, title: "删除") {
            action, index in
            self.tabTitleArray.remove(at: indexPath.row)
            UserDefaults.standard.setValue(self.tabTitleArray, forKey: "totalAddressBookInfo")
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        delete.backgroundColor = UIColor.red
        return [edit, delete]
    }
 
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            tabTitleArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
}
