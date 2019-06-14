//
//  USEWalletMineCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/1.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEWalletMineCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: -LazyloadKit
    lazy var leftImageView: UIImageView = UIImageView(image: UIImage.init(named: "u27"))
    lazy var titleLabel: UILabel = UILabel(title: "地址簿", fontSize: 15, color: UIColor.black, redundance: 0)
    lazy var rightImageView: UIImageView = UIImageView(image: UIImage.init(named: "next"), highlightedImage: UIImage.init(named: "next"))
    
}

extension USEWalletMineCell {
    fileprivate func setupUI() {
        //addSubviews
        self.contentView.addSubview(leftImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(rightImageView)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        // layout
        leftImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(20)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(leftImageView.snp.right).offset(20)
        }
        rightImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-20)
        }
    }
}
