//
//  USEWalletImportBaseVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/5/24.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEWalletImportBaseVC: UIViewController {
    
    @objc  func clickedBtn(btn: UIButton) {
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
        prepareTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    //MARK: --Lazyloadkit
     lazy var tabView: UITableView = UITableView()
     lazy var importBtn: UIButton = {
        let temp = UIButton(title: "开始导入", fontSize: 16, color: UIColor.white, imageName: nil, backColor: UIColor(hexString: "3289fc"))
        temp.layer.cornerRadius = 25
        temp.addTarget(self, action: #selector(USEWalletImportBaseVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
}

extension USEWalletImportBaseVC {
    fileprivate func setupUI() {
        // addSubviews
        self.view.addSubview(tabView)
        self.view.addSubview(importBtn)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        // layoutSubviews
        tabView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.bottom.right.equalTo(self.view)
        }
        importBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-35)
        }
    }
    
    fileprivate func prepareTableView() {
        tabView.delegate = self
        tabView.dataSource  = self
        tabView.tableFooterView = UIView()
        tabView.separatorStyle = .none
        tabView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tabView.register(USEImportWalletInputCell.self, forCellReuseIdentifier: USEImportInputCellID)
        tabView.register(USEImportWalletPasscodeCell.self, forCellReuseIdentifier: USEImportPasscodeCellID)
        tabView.register(USEImportWalletRepeatPasscodeCell.self, forCellReuseIdentifier: USEImportRepeatPasscodeCellID)
        tabView.register(USEImportWalletPasscodeAttentionCell.self, forCellReuseIdentifier: USEImportPasscodeAttentionCellID)
    }
}

extension USEWalletImportBaseVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: USEImportInputCellID) as! USEImportWalletInputCell
            return cell
        } else if indexPath.item == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: USEImportPasscodeCellID) as! USEImportWalletPasscodeCell
            return cell
        } else if indexPath.item == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: USEImportRepeatPasscodeCellID) as! USEImportWalletRepeatPasscodeCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: USEImportPasscodeAttentionCellID) as! USEImportWalletPasscodeAttentionCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 195
        } else {
            return 60
        }
    }
    
}
