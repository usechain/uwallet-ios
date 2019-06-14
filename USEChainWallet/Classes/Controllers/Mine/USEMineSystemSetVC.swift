//
//  USEMineSystemSetVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/30.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEWalletMineCellID = "USEWalletMineCellID"

class USEMineSystemSetVC: USEWalletBaseVC {
    
    override func loadView() {
        super.loadView()
        setupUI()
        perpareTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "系统设置"
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

extension USEMineSystemSetVC {
    
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

extension USEMineSystemSetVC: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func perpareTableView() {
        mineTableView.delegate = self
        mineTableView.dataSource = self
        mineTableView.register(UITableViewCell.self, forCellReuseIdentifier: USEWalletMineCellID)
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
        let cell = UITableViewCell()
        let rightImageView = UIImageView(image: UIImage.init(named: "next"))
        cell.contentView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(cell.contentView)
            make.right.equalTo(cell.contentView).offset(-10)
        }
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.textLabel?.text = "语言"
        } else {
            cell.textLabel?.text = "货币单位"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(USEMineTrueLaunageVC(), animated: true)
        } else {
            self.navigationController?.pushViewController(USEMineCoinUnitVC(), animated: true)
        }
    }
    
}
