//
//  USEMineCoinUnitVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/30.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEMineLaguageCellID = "USEMineLaguageCellID"

class USEMineCoinUnitVC: USEWalletBaseVC {
    
    override func loadView() {
        super.loadView()
        setupUI()
        perpareTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    //MARK: -Lazyloadkit
    fileprivate lazy var mineTableView: UITableView = UITableView()
    
}

extension USEMineCoinUnitVC {
    
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

extension USEMineCoinUnitVC: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func perpareTableView() {
        mineTableView.delegate = self
        mineTableView.dataSource = self
        mineTableView.register(USEMineLaguageCell.self, forCellReuseIdentifier: USEMineLaguageCellID)
        mineTableView.tableFooterView = UIView()
        mineTableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "USEMineLaguageCellID") as! USEMineLaguageCell
        if indexPath.row == 0 {
            cell.leftLabel.text = "人民币"
            let currerntLanguage = UserDefaults.standard.value(forKey: "USECurrentCoinType") as? String
            if currerntLanguage == "RMB" || currerntLanguage == nil {
                cell.rightImageView.isHidden = false
            } else {
                cell.rightImageView.isHidden = true
            }
        } else {
            cell.leftLabel.text = "美元"
            let currerntLanguage = UserDefaults.standard.value(forKey: "USECurrentCoinType") as? String
            if currerntLanguage == "USD" {
                cell.rightImageView.isHidden = false
            } else {
                cell.rightImageView.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UserDefaults.standard.setValue("RMB", forKey: "USECurrentCoinType")
            self.navigationController?.popViewController(animated: true)
        } else {
            UserDefaults.standard.setValue("USD", forKey: "USECurrentCoinType")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
