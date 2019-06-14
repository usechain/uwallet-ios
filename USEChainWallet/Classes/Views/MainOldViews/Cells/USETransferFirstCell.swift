
//
//  USETransferFirstCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/25.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USETransferFirstCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var backView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor(red: 41/255, green: 126/255, blue: 251/255, alpha: 1.0)
        temp.layer.cornerRadius = 10
        return temp
    }()
    lazy var coinLabel: UILabel = UILabel(title: "3,000,000.1", fontSize: 30, color: UIColor.white, redundance: 140)
    fileprivate lazy var coinType: UILabel = UILabel(title: "USE", fontSize: 16, color: UIColor.white, redundance: 0)
}

extension USETransferFirstCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(backView)
        backView.addSubview(coinLabel)
        backView.addSubview(coinType)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
        coinLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(backView)
            make.centerX.equalTo(backView)
        }
        coinType.snp.makeConstraints { (make) in
            make.centerY.equalTo(coinLabel)
            make.left.equalTo(coinLabel.snp.right).offset(10)
        }
    }
}
