//
//  USEImportWalletInputCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/18.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEImportWalletInputCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.selectionStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var topLabel: UILabel = UILabel(title: "使用助记词导入的同时，可以重新设置钱包密码", fontSize: 12, color: UIColor(hexString: "666666") ?? UIColor.red, redundance: 10)
    lazy var inputTextView: UITextView = {
        let temp = UITextView()
        temp.font = UIFont.systemFont(ofSize: 15)
        temp.delegate = self
        temp.layer.backgroundColor = UIColor.clear.cgColor
        temp.layer.borderColor = UIColor(hexString: "333333")?.cgColor
        temp.layer.borderWidth = 1.0;
        temp.layer.masksToBounds = true
        temp.layer.cornerRadius = 8
        temp.delegate = self
        return temp
    }()
    lazy var placeHolder: UILabel = {
        let temp = UILabel(title: "输入助记词，用空格分隔", fontSize: 15, color: UIColor(hexString: "999999") ?? UIColor.gray, redundance: 0)
        temp.alpha = 0.59
        return temp
    }()
}

extension USEImportWalletInputCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(topLabel)
        self.contentView.addSubview(inputTextView)
        self.inputTextView.addSubview(placeHolder)
        
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(10)
        }
        inputTextView.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(15)
            make.left.equalTo(topLabel)
            make.right.equalTo(self.contentView.snp.right).offset(-10)
            make.height.equalTo(153)
        }
        placeHolder.snp.makeConstraints { (make) in
            make.top.equalTo(inputTextView).offset(10)
            make.left.equalTo(inputTextView).offset(10)
        }
    }
}

extension USEImportWalletInputCell: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.placeHolder.isHidden = true
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.characters.count == 0 {
            self.placeHolder.isHidden = false
        }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "USEImportWalletContent"), object: nil, userInfo: ["text": textView.text])
    }
    
}
