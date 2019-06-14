//
//  USEImportWalletPasscodeAttentionCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/18.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEImportWalletPasscodeAttentionCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.selectionStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var passcodeAttentionLabel: UITextField = {
        let temp = UITextField()
        temp.font = UIFont.systemFont(ofSize: 16)
        temp.textColor = UIColor(hexString: "333333")
        temp.placeholder = "密码提示信息（选填）"
        return temp
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor(hexString: "333333")
        temp.alpha = 0.25
        return temp
    }()
    
}

extension USEImportWalletPasscodeAttentionCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(passcodeAttentionLabel)
        self.contentView.addSubview(bottomLine)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        passcodeAttentionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-10)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(passcodeAttentionLabel)
            make.height.equalTo(1)
            make.right.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.contentView)
        }
    }
}
