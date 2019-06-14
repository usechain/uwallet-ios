//
//  USETransferThirdCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/25.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

protocol USETransferThirdCellBtnClicked: NSObjectProtocol {
    func clickedAddressBook(btn: UIButton)
}

class USETransferThirdCell: UITableViewCell {
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
        delegate?.clickedAddressBook(btn: btn)
    }
    
    weak var delegate: USETransferThirdCellBtnClicked?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var tranferLabel: UILabel = UILabel(title: "收款地址:", fontSize: 16, color: UIColor.black, redundance: 0)
    lazy var moneyTextFiled: UITextField = {
        let temp = UITextField()
        temp.placeholder = "请输入Usechain地址"
        return temp
    }()
    
    fileprivate lazy var addressBookBtn: UIButton = {
        let temp = UIButton(imageName: "u750", backImageName: nil)
        temp.addTarget(self, action: #selector(USETransferThirdCell.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0)
        return temp
    }()
    fileprivate lazy var mentionLaebl: UILabel = UILabel(title: "提示:仅支持转账至Usechain链上地址,请勿输入其他网络地址", fontSize: 12, color: UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0), redundance: 10)
}
extension USETransferThirdCell {
    fileprivate func setupUI() {
        
        self.contentView.addSubview(tranferLabel)
        self.contentView.addSubview(moneyTextFiled)
        self.contentView.addSubview(bottomLine)
        self.contentView.addSubview(mentionLaebl)
        self.contentView.addSubview(addressBookBtn)
        
        tranferLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top).offset(20)
            make.left.equalTo(self.contentView).offset(15)
        }
        addressBookBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(tranferLabel)
            make.right.equalTo(self.contentView).offset(-20)
            make.height.width.equalTo(20)
        }
        moneyTextFiled.snp.makeConstraints { (make) in
            make.top.equalTo(tranferLabel.snp.bottom).offset(5)
            make.left.equalTo(tranferLabel)
            make.right.equalTo(self.contentView.snp.right).offset(-10)
            make.height.equalTo(40)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(moneyTextFiled)
            make.right.equalTo(self.contentView).offset(-15)
            make.top.equalTo(moneyTextFiled.snp.bottom).offset(-4)
            make.height.equalTo(1)
        }
        mentionLaebl.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLine.snp.bottom).offset(5)
            make.left.equalTo(bottomLine)
            make.right.equalTo(bottomLine)
        }
    }
}

