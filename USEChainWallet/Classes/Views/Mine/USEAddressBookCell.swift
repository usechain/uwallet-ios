//
//  USEAddressBookCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/30.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEAddressBookCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     lazy var topLabel: UILabel = UILabel(title: "OK钱包(OKex交易所)", fontSize: 16, color: UIColor.black, redundance: 0)
     lazy var addressLabel: UILabel = UILabel(title: "0x123123...123123", fontSize: 16, color: UIColor.black, redundance: 20)
    
}

extension USEAddressBookCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(topLabel)
        self.contentView.addSubview(addressLabel)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(10)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topLabel)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
    }
}
