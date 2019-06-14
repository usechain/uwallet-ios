//
//  USEKYCConfirmInfoCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/20.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEKYCConfirmInfoCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.selectionStyle = .none
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var cellTitleLabel: UILabel = {
        let temp = UILabel(title: "国家/地区:", fontSize: 16, color: UIColor.black, redundance: 0)
        return temp
    }()
    lazy var cellContentLabel: UILabel = {
        let temp = UILabel(title: "中国大陆", fontSize: 16, color: UIColor.black, redundance: 0)
        return temp
    }()
}

extension USEKYCConfirmInfoCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(cellTitleLabel)
        self.contentView.addSubview(cellContentLabel)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        cellTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView.snp.left).offset(10)
        }
        cellContentLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView.snp.left).offset(120)
        }
    }
}
