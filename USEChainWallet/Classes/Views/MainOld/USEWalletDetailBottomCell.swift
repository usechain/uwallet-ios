//
//  USEWalletDetailBottomCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/19.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEWalletDetailBottomCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.selectionStyle = .none
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var deleteLabel: UILabel = UILabel(title: "删除钱包", fontSize: 16, color: UIColor.red, redundance: 0)
    fileprivate lazy var topGrayView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        return temp
    }()
}

extension USEWalletDetailBottomCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(deleteLabel)
        self.contentView.addSubview(topGrayView)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        topGrayView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.contentView)
            make.height.equalTo(30)
        }
        deleteLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(topGrayView.snp.bottom).offset(25)
        }
    }
}
