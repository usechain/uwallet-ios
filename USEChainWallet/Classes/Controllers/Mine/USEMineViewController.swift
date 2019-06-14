//
//  USEMineViewController.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/1.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEWalletMineCellID = "USEWalletMineCellID"

class USEMineViewController: UIViewController {

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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
 
    }
    //MARK: -Lazyloadkit
    fileprivate lazy var topBackView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor(red: 10/255, green: 52/255, blue: 105/255, alpha: 1.0)
        return temp
    }()
    fileprivate lazy var topImageView: UIImageView = UIImageView(image: UIImage.init(named: "u47"))
    fileprivate lazy var titleLabel: UILabel = UILabel(title: "USE", fontSize: 15, color: UIColor.white, redundance: 0)
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        return view
    }()
    fileprivate lazy var mineTableView: UITableView = UITableView()
    fileprivate lazy var tabTitleArray: Array = { () -> [String] in
        let temp = ["地址簿", "消息中心", "系统设置", "加入社区", "帮助中心", "关于我们"]
        return temp
    }()
    fileprivate lazy var tabImageArray: Array = { () -> [String] in
        let temp = ["dizhi", "xiaoxi", "shezhi", "jiaru", "bangzhu", "guanyu"]
        return temp
    }()

}

extension USEMineViewController {
    fileprivate func setupUI() {
        //addSubviews
        self.view.addSubview(topBackView)
        topBackView.addSubview(topImageView)
        topBackView.addSubview(titleLabel)
        self.view.addSubview(lineView)
        self.view.addSubview(mineTableView)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        // layout
        topBackView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(250)
        }
        topImageView.snp.makeConstraints { (make) in
            make.center.equalTo(topBackView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(topBackView)
            make.top.equalTo(topImageView.snp.bottom).offset(20)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(topBackView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(10)
        }
        mineTableView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
}

extension USEMineViewController: UITableViewDelegate, UITableViewDataSource {
    fileprivate func perpareTableView() {
        mineTableView.delegate = self
        mineTableView.dataSource = self
        mineTableView.register(USEWalletMineCell.self, forCellReuseIdentifier: USEWalletMineCellID)
        mineTableView.tableFooterView = UIView()
        mineTableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: USEWalletMineCellID) as! USEWalletMineCell
        cell.leftImageView.image = UIImage.init(named: tabImageArray[indexPath.row])
        cell.titleLabel.text = tabTitleArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
        
            self.navigationController?.pushViewController(USEMineAddressBookVC(), animated: true)
        case 1:
            self.navigationController?.pushViewController(USEMineMessageCenterVC(), animated: true)
        case 2:
            self.navigationController?.pushViewController(USEMineSystemSetVC(), animated: true)
        case 3:
            self.navigationController?.pushViewController(USEMineJoinCommunityVC(), animated: true)
        case 4:
            self.navigationController?.pushViewController(USEMineHelpUsVC(), animated: true)
        case 5:
            self.navigationController?.pushViewController(USEMineAboutUsVC(), animated: true)
        default:
            self.navigationController?.pushViewController(USEMineAddressBookVC(), animated: true)
        }
    }
}
