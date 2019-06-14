//
//  USETransferSecondCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/25.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USETransferSecondCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var tranferLabel: UILabel = UILabel(title: "转账金额:", fontSize: 16, color: UIColor.black, redundance: 0)
    lazy var moneyTextFiled: UITextField = {
        let temp = UITextField()
        temp.placeholder = "输入金额"
        temp.keyboardType = UIKeyboardType.numbersAndPunctuation
        temp.keyboardType = UIKeyboardType.decimalPad
        return temp
    }()
    fileprivate lazy var bottomLine: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0)
        return temp
    }()
}
extension USETransferSecondCell {
    fileprivate func setupUI() {
        
        self.contentView.addSubview(tranferLabel)
        self.contentView.addSubview(moneyTextFiled)
        self.contentView.addSubview(bottomLine)
        
        tranferLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top).offset(20)
            make.left.equalTo(self.contentView).offset(15)
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
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(1)
        }
    }
}
