//
//  USERecoverWalletCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/6/5.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

protocol USERecoverWalletCellBtnClicked: NSObjectProtocol {
    func clicked(btn: UIButton)
}

class USERecoverWalletCell: UITableViewCell {
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
        delegate?.clicked(btn: btn)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.selectionStyle = .none
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    weak var delegate: USERecoverWalletCellBtnClicked?
    lazy var leftBtn: UIButton = {
        let btn = UIButton(imageName: "user_zhuce1", backImageName: nil)
        btn.addTarget(self, action: #selector(USERecoverWalletCell.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        btn.setImage(UIImage.init(named: "user_zhuce2"), for: UIControl.State.selected)
        return btn
    }()
    lazy var rightWalletNameLable: UILabel = UILabel(title: "aaaaaaaaa", fontSize: 16, color: UIColor.black, redundance: 0)
    lazy var rightAddressLabel: UILabel = UILabel(title: "asdasdasdasdasd", fontSize: 16, color: UIColor.black, redundance: 0)
    fileprivate lazy var bottomLine: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.black
        return temp
    }()
    var walletStore: String?
}
extension USERecoverWalletCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(leftBtn)
        self.contentView.addSubview(rightWalletNameLable)
        self.contentView.addSubview(rightAddressLabel)
        self.contentView.addSubview(bottomLine)
        
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        leftBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(20)
        }
        rightWalletNameLable.snp.makeConstraints { (make) in
            make.left.equalTo(leftBtn.snp.right).offset(20)
            make.top.equalTo(self.contentView).offset(10)
        }
        rightAddressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(rightWalletNameLable)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(1)
            make.left.right.equalTo(self.contentView)
        }
    }
}

