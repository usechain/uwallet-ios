//
//  USEEvaluateTransactionVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/6/4.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEKYCCAChooseCellID = "USEKYCCAChooseCellID"
private let USEKYCConfirmBtnCellID = "USEKYCConfirmBtnCellID"

class USEEvaluateTransactionVC: USEWalletBaseVC {
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
        let detailTXDict = UserDefaults.standard.value(forKey: kCurrentTXDetail) as! Dictionary<String, Any>
        let walletStore = walletInfo[1]
        let correctPasscode = (UserDefaults.standard.value(forKey: walletStore) as! Array<String>).last
        let alertVC = UIAlertController(title: "请输入密码", message: "", preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        let confirmBtn = UIAlertAction(title: "确认", style: .destructive) { (action) in
            let textField = alertVC.textFields?.first
            if textField?.text == correctPasscode {
                self.view.showHUD(withText: "正在发送交易")
                let account = kGetCurrentAccount()
                let toAddress = UseChainNetTools.recoverToNormalAddress(umAddress: kEvalueateAddress)
                var othersNormalAddress = ""
                let umAddress = kGetCurrentAccountUMAdderss()
                if (detailTXDict["from"] as! String).lowercased() == umAddress.lowercased() {
                    othersNormalAddress = UseChainNetTools.recoverToNormalAddress(umAddress: detailTXDict["to"] as! String).dropHexPrefix
                } else {
                    othersNormalAddress  = UseChainNetTools.recoverToNormalAddress(umAddress: detailTXDict["from"] as! String).dropHexPrefix
                }
                var evaluatePointStr = ""
                switch self.selectedBtn.tag {
                case 0: evaluatePointStr = "01"
                case 1: evaluatePointStr = "00"
                case 2: evaluatePointStr = "f1"
                default:
                    evaluatePointStr = "01"
                }
                let tempDataStr = (detailTXDict["hash"] as! String) + othersNormalAddress + evaluatePointStr
                let tempData = tempDataStr.hexToBytes
                UseChainNetTools.sendUSETransactionWith(account: account, gasLimite: "220000", gasPrice: "10000000000", value: "0", toAddress: toAddress, data: tempData as NSData?, flag: 6, resource: { (result, error) in
                    self.hideHUD()
                    if result != nil {
                        if (result as! [String: Any])["error"] != nil {
                            showAlterView("交易发送失败", mySelf: self)
                            return
                        }
                        UserDefaults.standard.setValue((result as! [String: Any])["result"], forKey: "currentTXHash")
                      self.navigationController?.pushViewController(USETransferCompletedVC(), animated: true)
                    } else {
                        showAlterView("交易发送失败", mySelf: self)
                        return
                    }
                })
            } else {
                showAlterView("密码错误", mySelf: self)
                return
            }
        }
        confirmBtn.setValue(UIColor.red, forKey: "titleTextColor")
        alertVC.addAction(cancelBtn)
        alertVC.addAction(confirmBtn)
        alertVC.addTextField { (textfiled) in
            textfiled.placeholder = "请输入密码"
        }
        self.present(alertVC, animated: true) {
        }
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
        prepareTableview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "交易评价"
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
    lazy var sourceArray: Array = ["好", "一般", "差"]
    fileprivate lazy var selectedBtn: UIButton = UIButton()
    fileprivate lazy var walletInfo: Array = { () -> [String] in
        let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        return useCurrentAccountArray ?? []
    }()
}

extension USEEvaluateTransactionVC {
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

extension USEEvaluateTransactionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row != 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: USEKYCCAChooseCellID) as! USEKYCCAChooseCell
            cell.leftBtn.tag = indexPath.row
            cell.leftBtn.isSelected = false
            cell.delegate = self
            if indexPath.row == 0 {
                self.selectedBtn = cell.leftBtn
                cell.leftBtn.isSelected = true
            }
            cell.rightLabel.text = sourceArray[indexPath.row]
            return cell
        } else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            let btn = UIButton(title: "确认", fontSize: 20, color: UIColor.white, imageName: nil, backColor: UIColor(red: 40/255, green: 113/255, blue: 251/255, alpha: 1.0))
            cell.contentView.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.center.equalTo(cell.contentView)
                make.width.equalTo(200)
            }
            btn.layer.cornerRadius = 20
            btn.addTarget(self, action: #selector(USEEvaluateTransactionVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 3 {
            return 50
        } else {
            return 200
        }
    }
    
}

extension USEEvaluateTransactionVC:USEKYCCAChooseCellBtnClicked {
    func clicked(btn: UIButton) {
        self.selectedBtn.isSelected = false
        btn.isSelected = true
        self.selectedBtn = btn
    }
}
