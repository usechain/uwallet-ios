//
//  USEWalletChangePasscodeInputCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/22.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEWalletChangePasscodeInputCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.selectionStyle = .none
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var inputFiled: UITextField = {
        let temp = UITextField()
        temp.font = UIFont.systemFont(ofSize: 20)
        temp.isSecureTextEntry = true
        return temp
    }()
}

extension USEWalletChangePasscodeInputCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(inputFiled)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }

        inputFiled.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(12)
        }
    }
}
