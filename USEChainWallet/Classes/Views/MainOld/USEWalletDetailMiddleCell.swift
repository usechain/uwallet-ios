//
//  USEWalletDetailMiddleCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/19.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEWalletDetailMiddleCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.selectionStyle = .none
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var leftImageView: UIImageView = {
        let temp = UIImageView(image: UIImage.init(named: "u78"))
        return temp
    }()
    lazy var titleLabel: UILabel = UILabel(title: "升级", fontSize: 16, color: UIColor.black, redundance: 0)
    lazy var rightImageView: UIImageView = UIImageView(image: UIImage.init(named: "u426"))
    fileprivate lazy var bottomLineView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 248/255, alpha: 1.0)
        return temp
    }()
}

extension USEWalletDetailMiddleCell {
    fileprivate func setupUI() {
        
        self.contentView.addSubview(leftImageView)
        self.contentView.addSubview(titleLabel)
//        self.contentView.addSubview(rightImageView)
        self.contentView.addSubview(bottomLineView)
        
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        leftImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(20)
            make.height.width.equalTo(20)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(leftImageView.snp.right).offset(20)
        }
//        rightImageView.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self.contentView)
//            make.right.equalTo(self.contentView.snp.right).offset(-20)
//            make.height.width.equalTo(20)
//        }
        bottomLineView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(titleLabel)
           // make.bottom.equalTo(self.contentView.bottom)
            make.height.equalTo(1)
            make.right.equalTo(self.contentView)
        }
    }
}
