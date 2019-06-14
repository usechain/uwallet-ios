//
//  USECAChooseVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/4/1.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEKYCCAChooseCellID = "USEKYCCAChooseCellID"
private let USEKYCConfirmBtnCellID = "USEKYCConfirmBtnCellID"

class USEKYCCAChooseVC: USEWalletBaseVC {

    @objc fileprivate func clickedBtn(btn: UIButton) {
        self.navigationController?.pushViewController(USEKYCAuthenticationVC(), animated: true)
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
        prepareTableview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "CA认证服务商"
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
    
    fileprivate lazy var tabView: UITableView  = UITableView()
    
}

extension USEKYCCAChooseVC {
    
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
        tabView.register(USEKYCCAChooseCell.self, forCellReuseIdentifier: USEKYCCAChooseCellID)
        tabView.register(USEKYCConfirmBtnCell.self, forCellReuseIdentifier: USEKYCConfirmBtnCellID)
    }
    
}

extension USEKYCCAChooseVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: USEKYCCAChooseCellID) as! USEKYCCAChooseCell
            cell.delegate = self
            cell.leftBtn.isSelected = true
            return cell
        } else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            let btn = UIButton(title: "下一步", fontSize: 20, color: UIColor.white, imageName: nil, backColor: UIColor(red: 40/255, green: 113/255, blue: 251/255, alpha: 1.0))
            cell.contentView.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.center.equalTo(cell.contentView)
                make.width.equalTo(200)
            }
            btn.layer.cornerRadius = 20
            btn.addTarget(self, action: #selector(USEKYCCAChooseVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            return 200
        }
    }
    
}

extension USEKYCCAChooseVC: USEKYCCAChooseCellBtnClicked {
    func clicked(btn: UIButton) {
        btn.isSelected = !btn.isSelected
    }
}
