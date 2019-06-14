//
//  USEKYCConfirmVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/20.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

private let USEKYCConfirmInfoCellID = "USEKYCConfirmInfoCellID"
private let USEKYCConfirmImageCellID = "USEKYCConfirmImageCellID"
private let USEKYCConfirmBtnCellID = "USEKYCConfirmBtnCellID"

class USEKYCConfirmVC: USEWalletBaseVC {

    override func loadView() {
        super.loadView()
        setupUI()
        prepareTableView()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "提交审核"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userInfo = []
        let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let KYCUserKey = "KYCUserInfo" + ((accountInfo?.last!)!)
        let userDict = UserDefaults.standard.value(forKey: KYCUserKey) as! [String: String]
        userInfo.append(userDict["nation"]!)
        if userDict["certtype"] == "1" {
            userInfo.append("身份证")
        } else {
            userInfo.append("护照")
        }
        userInfo.append(userDict["name"]!)
        if userDict["sex"]! == "1" {
            userInfo.append("男")
        } else {
            userInfo.append("女")
        }
        userInfo.append(userDict["birthday"]!)
        userInfo.append(userDict["id"]!)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        userInfo = []
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    fileprivate var userInfo: Array = [""]
    fileprivate var cellTitleArray: Array = ["国家", "证件类型", "姓名", "性别", "出生日期", "证件号码"]
    fileprivate lazy var topWarningLabel: UILabel = UILabel(title: "★请确认您的KYC信息真实有效，否则将无法通过审核，无法完成地址升级", fontSize: 16, color: UIColor.black, redundance: 10)
    fileprivate lazy var bottomWarningLabel: UILabel = UILabel(title: "★Usechain钱包不会保留您的任何认证数据，所有认证信息数据将会加密提交至权威第三方CA机构，保证您的隐私安全", fontSize: 16, color: UIColor.black, redundance: 10)
    fileprivate lazy var warningLine: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.black
        return temp
    }()
    fileprivate lazy var tabView: UITableView = {
        let temp = UITableView()
        temp.tableFooterView = UIView()
        return temp
    }()
    
}

extension USEKYCConfirmVC {
    
    fileprivate func setupUI() {
        self.view.addSubview(topWarningLabel)
        self.view.addSubview(bottomWarningLabel)
        self.view.addSubview(warningLine)
        self.view.addSubview(tabView)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        topWarningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(10)
        }
        bottomWarningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topWarningLabel.snp.bottom).offset(20)
            make.left.equalTo(topWarningLabel)
        }
        warningLine.snp.makeConstraints { (make) in
            make.top.equalTo(bottomWarningLabel.snp.bottom).offset(10)
            make.left.right.equalTo(self.view)
            make.height.equalTo(1)
        }
        tabView.snp.makeConstraints { (make) in
            make.top.equalTo(warningLine.snp.bottom).offset(20)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    fileprivate func prepareTableView() {
        tabView.delegate = self as UITableViewDelegate
        tabView.dataSource = self
        tabView.register(USEKYCConfirmInfoCell.self, forCellReuseIdentifier: USEKYCConfirmInfoCellID)
        tabView.register(USEKYCConfirmImageCell.self, forCellReuseIdentifier: USEKYCConfirmImageCellID)
        tabView.register(USEKYCConfirmBtnCell.self, forCellReuseIdentifier: USEKYCConfirmBtnCellID)
        tabView.separatorStyle = .none
    }
    
}

extension USEKYCConfirmVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cardType = UserDefaults.standard.value(forKey: kKycCardType) as! String
        if cardType == kIDCard {
            return 10
        } else {
            // passport
            return 9
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row <= 5 {
            // plainText
            let cell = tableView.dequeueReusableCell(withIdentifier: USEKYCConfirmInfoCellID) as! USEKYCConfirmInfoCell
            cell.cellTitleLabel.text = cellTitleArray[indexPath.row]
            cell.cellContentLabel.text = userInfo[indexPath.row]
            print(userInfo.count)
            return cell
        } else if indexPath.row <= 9 {
            // image
            let cardType = UserDefaults.standard.value(forKey: kKycCardType) as! String
            if cardType == kIDCard {
                let cell = tableView.dequeueReusableCell(withIdentifier: USEKYCConfirmImageCellID) as! USEKYCConfirmImageCell
                if indexPath.row == 6 {
                    cell.identidierCardImageView.image = UIImage.getWithName("frontImage")
                    cell.identifierCardTitleLabel.text = "身份证正面照片"
                }else if indexPath.row == 7 {
                    cell.identidierCardImageView.image =  UIImage.getWithName("BackImage")
                    cell.identifierCardTitleLabel.text = "身份证背面照片"
                } else if indexPath.row == 8 {
                    cell.identidierCardImageView.image =  UIImage.getWithName("HoldImage")
                    cell.identifierCardTitleLabel.text = "手持身份证照片"
                } else if indexPath.row == 9 {
                    let cell = tabView.dequeueReusableCell(withIdentifier: USEKYCConfirmBtnCellID) as! USEKYCConfirmBtnCell
                    cell.delegate  = self
                    cell.confirmBtn.isHidden = false
                    return cell
                }
                return cell
            } else {
                // passport
                let cell = tableView.dequeueReusableCell(withIdentifier: USEKYCConfirmImageCellID) as! USEKYCConfirmImageCell
                if indexPath.row == 6 {
                    cell.identidierCardImageView.image = UIImage.getWithName("frontImage")
                    cell.identifierCardTitleLabel.text = "护照照片"
                }else if indexPath.row == 7 {
                    cell.identidierCardImageView.image =  UIImage.getWithName("HoldImage")
                    cell.identifierCardTitleLabel.text = "手持护照照片"
                } else if indexPath.row == 8 {
                    let cell = tabView.dequeueReusableCell(withIdentifier: USEKYCConfirmBtnCellID) as! USEKYCConfirmBtnCell
                    cell.delegate  = self
                    cell.confirmBtn.isHidden = false
                    return cell
                }
                return cell
            }
        } else {
            // confirmBtn
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row <= 5 {
            // plainText
            return 44
        } else if indexPath.row <= 9 {
            let cardType = UserDefaults.standard.value(forKey: kKycCardType) as! String
            if cardType == kIDCard {
                if indexPath.row == 9 {
                    return 50
                }
                    return 274
            } else {
                // passport
                if indexPath.row == 8 {
                    return 80
                }
                return 247
            }
        }
        return 300
    }
    
}

extension USEKYCConfirmVC: USEKYCConfirmBtnCellBtnClicked {
    func clicked(btn: UIButton) {
        self.navigationController?.pushViewController(USEKYCAuditingVC(), animated: true)
    }
}
