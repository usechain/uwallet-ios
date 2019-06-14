//
//  USETransferCompletedLabelCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/25.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USETransferCompletedLabelCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     lazy var titleLabel: UILabel = UILabel(title: "收款地址", fontSize: 16, color: UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0), redundance: 0)
     lazy var contentLabel: UILabel = UILabel(title: "", fontSize: 16, color: UIColor.black, redundance: 115)
}

extension USETransferCompletedLabelCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(contentLabel)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(12)
            make.left.equalTo(self.contentView).offset(12)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel).offset(-2)
            make.left.equalTo(self.contentView).offset(100)
            make.bottom.equalTo(self.contentView).offset(-12)
        }
    }
}
