//
//  USEMineJoinCommunityVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/30.
//  Copyright © 2019 Jacob. All rights reserved.
//


import UIKit

private let USEMineJoinCommunityCellID = "USEMineJoinCommunityCellID"

class USEMineJoinCommunityVC: USEWalletBaseVC {
    
    override func loadView() {
        super.loadView()
        setupUI()
        perpareTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "加入社区"
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
    fileprivate lazy var tabTitleArray: Array = { () -> [String] in
        let temp = ["Wechat", "TelegramCN", "TelegramEN", "Twitter", "Facebook", "Weibo", "官网"]
        return temp
    }()
    fileprivate lazy var rightTitleArray: Array = { () -> [String] in
        let temp = ["usechain-yoyo", "t.me/usechain2", "t.me/usechaingroup", "twitter.com/usechain", "www.facebook.com/UsechainFoundation", "usechain", "www.usechain.net"]
        return temp
    }()
    
}

extension USEMineJoinCommunityVC {
    
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

extension USEMineJoinCommunityVC: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func perpareTableView() {
        mineTableView.delegate = self
        mineTableView.dataSource = self
        mineTableView.register(USEMineJoinCommunityCell.self, forCellReuseIdentifier: USEMineJoinCommunityCellID)
        mineTableView.tableFooterView = UIView()
        mineTableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: USEMineJoinCommunityCellID) as! USEMineJoinCommunityCell
        cell.leftLabel.text = tabTitleArray[indexPath.row]
        cell.rightLabel.text = rightTitleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pasteboard = UIPasteboard.general
        let currentCell = tableView.cellForRow(at: indexPath) as! USEMineJoinCommunityCell
        pasteboard.string = currentCell.rightLabel.text
        showAlterView("信息复制成功", mySelf: self)
    }
    
}
