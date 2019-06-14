//
//  USEKYCConfirmImageCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/20.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEKYCConfirmImageCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.selectionStyle = .none
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var identifierCardTitleLabel: UILabel = UILabel(title: "身份证正面照片:", fontSize: 18, color: UIColor.black, redundance: 0)
    lazy var identidierCardImageView: UIImageView = {
        let temp = UIImageView(image: UIImage.init(named: "身份证正面"))
        return temp
    }()
    
}

extension USEKYCConfirmImageCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(identifierCardTitleLabel)
        self.contentView.addSubview(identidierCardImageView)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        identifierCardTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(10)
        }
        identidierCardImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(identifierCardTitleLabel.snp.bottom).offset(20)
            make.height.equalTo(200)
            make.left.equalTo(self.contentView).offset(40)
            make.right.equalTo(self.contentView).offset(-40)
        }
    }
}
