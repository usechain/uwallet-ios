//
//  USEMineJoinCommunityCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/31.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEMineJoinCommunityCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var leftLabel: UILabel = UILabel(title: "简体中文", fontSize: 16, color: UIColor.black, redundance: 0)
    lazy var rightLabel: UILabel = {
        let temp = UILabel(title: "简体中文", fontSize: 16, color: UIColor.black, redundance: 0)
        return temp
    }()
}

extension USEMineJoinCommunityCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(rightLabel)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        leftLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(5)
            make.left.equalTo(self.contentView).offset(10)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView).offset(-5)
            make.right.equalTo(self.contentView).offset(-8)
        }
    }
}
