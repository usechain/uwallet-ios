//
//  USETransferCompletedVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/25.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USETransferCompletedLabelCellID = "USETransferCompletedLabelCellID"
private let USETransferCompletedBtnCellID = "USETransferCompletedBtnCellID"

class USETransferCompletedVC: USEWalletBaseVC {

    @objc fileprivate func clickedBtn(btn: UIButton) {
        self.navigationController?.pushViewController(USEEvaluateTransactionVC(), animated: true)
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
        prepareTableview()
        cusRightBtn()
        let txhash = UserDefaults.standard.value(forKey: "currentTXHash") as? String
        UseChainNetTools.getUSETransactionByHash(txHash: ((txhash ?? ""))) { (result, error) in
            if result != nil {
                if ((result as! [String: Any])["error"]) != nil {
                    showAlterView("转账失败", mySelf: self)
                    self.successLabel.text = "转账失败"
                    self.successImageView.image = UIImage.init(named: "guandiao")
                    return
                }
                 let resultDict = ((result as! [String: Any])["result"]) as? [String: Any]
                if resultDict == nil {
                    return
                }
                let bigNumResultValue = BigNumber(hexString: resultDict?["value"] as? String)
                let tempStr = Payment.formatEther(bigNumResultValue, options: (EtherFormatOption.commify.rawValue | EtherFormatOption.approximate.rawValue))
                let bigNumResultGas = BigNumber(hexString: resultDict?["gas"] as? String)
                let bigNumResultGasPrice = BigNumber(hexString: resultDict!["gasPrice"] as? String)
                let bigNumResultGasUsed = bigNumResultGas?.mul(bigNumResultGasPrice)
                let tempGasUsedStr = Payment.formatEther(bigNumResultGasUsed, options: (EtherFormatOption.commify.rawValue | EtherFormatOption.approximate.rawValue))
                if resultDict!["to"] is NSNull {
                            showAlterView("转账失败", mySelf: self)
                            self.successLabel.text = "转账失败"
                            self.successImageView.image = UIImage.init(named: "guandiao")
                            return
                }
                let partResultDict = ["from": resultDict!["from"], "to": resultDict!["to"], "hash": resultDict!["hash"]];
                UserDefaults.standard.setValue(partResultDict, forKey: kCurrentTXDetail)
                if let blockNumber: NSNumber = UseEthersManager.numberHexString(resultDict!["blockNumber"] as? String) {
                    self.contentLabelArray = [tempStr, tempGasUsedStr, resultDict!["to"], resultDict!["from"], resultDict!["input"], resultDict!["hash"], blockNumber.stringValue] as! [String]
                } else {
                    self.contentLabelArray = [tempStr, tempGasUsedStr, resultDict?["to"], resultDict!["from"], resultDict!["input"], resultDict!["hash"], "<null>"] as! [String]
                }
                self.successLabel.text = "转账成功"
                let txToAddress = resultDict!["to"] as! String
                let currentAddress = "0x" + self.walletInfo.last! as String
                let storeAddress = (currentAddress == txToAddress ? resultDict!["from"] : resultDict!["to"]) as! String
                 self.tabView.reloadData()
                    for array in UserDefaults.standard.value(forKey: "totalAddressBookInfo") as? [[Any]] ?? [] {
                        if array.last as! String == storeAddress {
                            return
                        }
                    }
                    UserDefaults.standard.setValue(10000, forKey: "wannaChangeIndex")
                    UserDefaults.standard.synchronize() 
                    self.addAddressToAddressBook(address: storeAddress)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "交易详情"
        self.view.backgroundColor = UIColor.white
    }
    
    fileprivate lazy var walletInfo: Array = { () -> [String] in
        let useCurrentAccountArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        return useCurrentAccountArray ?? []
    }()
    fileprivate var contentLabelArray = Array<String>()
    fileprivate lazy var successImageView: UIImageView = {
        let temp = UIImageView()
        temp.image = UIImage.init(named: "complete")
        return temp
    }()
    fileprivate lazy var successLabel: UILabel = UILabel(title: "转账", fontSize: 16, color: UIColor(red: 34/255, green: 129/255, blue: 252/255, alpha: 1.0), redundance: 0)
    fileprivate lazy var timeLaebl: UILabel = {
    var temp = UILabel(title: "2019-02-23 22:10:29 UTC+8", fontSize: 14, color: UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0), redundance: 0)
    let currentDate = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let timeStr = formatter.string(from: currentDate)
    temp.text = timeStr
    return temp
    }()
    fileprivate lazy var tabView: UITableView = UITableView()
    fileprivate  var titleArray: Array = ["金额:", "矿工费用:", "收款地址:", "付款地址:", "备注:", "交易ID:", "区块号:"]
    
}

extension USETransferCompletedVC {
    
    fileprivate func setupUI() {
        self.view.addSubview(successImageView)
        self.view.addSubview(successLabel)
        self.view.addSubview(timeLaebl)
        self.view.addSubview(tabView)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        successImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(30)
            make.height.width.equalTo(50)
        }
        successLabel.snp.makeConstraints { (make) in
            make.top.equalTo(successImageView.snp.bottom).offset(15)
            make.centerX.equalTo(self.view)
        }
        timeLaebl.snp.makeConstraints { (make) in
            make.top.equalTo(successLabel.snp.bottom).offset(15)
            make.centerX.equalTo(self.view)
        }
        tabView.snp.makeConstraints { (make) in
            make.top.equalTo(timeLaebl.snp.bottom).offset(30)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    fileprivate func prepareTableview() {
        tabView.tableFooterView = UIView()
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.register(USETransferCompletedLabelCell.self, forCellReuseIdentifier: USETransferCompletedLabelCellID)
        tabView.register(USETransferCompletedBtnCell.self, forCellReuseIdentifier: USETransferCompletedBtnCellID)
        tabView.estimatedRowHeight = 300
    }
    
}

extension USETransferCompletedVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: USETransferCompletedBtnCellID) as! USETransferCompletedBtnCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: USETransferCompletedLabelCellID) as! USETransferCompletedLabelCell
            if self.contentLabelArray.count != 0 {
                 cell.contentLabel.text = self.contentLabelArray[indexPath.row]
            }
            cell.titleLabel.text = self.titleArray[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 7 {
            let pasteboard = UIPasteboard.general
            let currentCell = tableView.cellForRow(at: indexPath) as! USETransferCompletedLabelCell
            pasteboard.string = currentCell.contentLabel.text
            showAlterView("信息复制成功", mySelf: self)
        }
    }
}

extension USETransferCompletedVC: USETransferCompletedBtnCellBtnClicked {
    
    func clicked(btn: UIButton) {

        self.navigationController?.pushViewController(USEMainNetWebviewVC(), animated: true)
    }
    
}

extension USETransferCompletedVC {
    
    fileprivate func cusRightBtn() {
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        backBtn.setImage(UIImage.init(named: "chuiziicon"), for: UIControl.State.normal)
        backBtn.setImage(UIImage.init(named: "chuiziicon"), for: UIControl.State.highlighted)
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let backItem = UIBarButtonItem.init(customView: backBtn)
        backBtn.addTarget(self, action: #selector(USETransferCompletedVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = backItem
    }
    
    fileprivate func addAddressToAddressBook(address: String) {
        let alertVC = UIAlertController(title: "是否将该地址添加到常用联系人", message: "", preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        let confirmBtn = UIAlertAction(title: "确认", style: .destructive) { (action) in
            
            UserDefaults.standard.setValue(address, forKey: "toAddressFromTransaction")
            self.navigationController?.pushViewController(USEMineNewContactorVC(), animated: true)
        }
        confirmBtn.setValue(UIColor.red, forKey: "titleTextColor")
        alertVC.addAction(cancelBtn)
        alertVC.addAction(confirmBtn)
        self.present(alertVC, animated: true) {
        }
    }
    
}
