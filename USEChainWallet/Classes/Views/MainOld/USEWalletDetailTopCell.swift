//
//  USEWalletDetailTopCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/19.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEWalletDetailTopCell: UITableViewCell {
    
    
    @objc private func clickedBtn(btn: UIButton) {

        let pasteboard = UIPasteboard.general
        let umAddress = kGetCurrentAccountUMAdderss()
        pasteboard.string = umAddress
        self.showAlterView("地址复制成功")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
        self.selectionStyle = .none
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var backView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor(red: 71/255, green: 160/255, blue: 235/255, alpha: 1.0)
        temp.layer.cornerRadius = 10
        return temp
    }()
    lazy var nameLabel: UILabel = {
        let temp = UILabel(title: "小优的钱包", fontSize: 16, color: UIColor.white, redundance: 0)
        return temp
    }()
    lazy var addressLabel: UILabel = {
        let temp = UILabel(title: "0xffDBFf3...B23D229", fontSize: 12, color: UIColor.white, redundance: 0)
        return temp
    }()
    fileprivate lazy var copyBtn: UIButton = {
        let temp = UIButton(imageName: "u661", backImageName: nil)
        temp.addTarget(self, action: #selector(USEWalletDetailTopCell.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    lazy var authImageView: UIImageView = {
        let temp = UIImageView.init(image: UIImage.init(named: "匿名标志"))
        return temp
    }()
    lazy var vipImageView: UIImageView = {
        let temp = UIImageView.init(image: UIImage.init(named: "钻石标志"))
        return temp
    }()
    
}

extension USEWalletDetailTopCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(backView)
        backView.addSubview(nameLabel)
        backView.addSubview(addressLabel)
        backView.addSubview(copyBtn)
        backView.addSubview(authImageView)
        backView.addSubview(vipImageView)
        
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        backView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.contentView).offset(10)
            make.bottom.right.equalTo(self.contentView).offset(-10)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backView).offset(22)
            make.left.equalTo(backView).offset(20)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(backView).offset(-22)
            make.left.equalTo(nameLabel)
        }
        copyBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(addressLabel)
            make.left.equalTo(addressLabel.snp.right).offset(10)
            make.width.height.equalTo(20)
        }
        vipImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(backView)
            make.right.equalTo(backView.snp.right).offset(-20)
            make.height.width.equalTo(30)
        }
        authImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(backView)
            make.right.equalTo(vipImageView.snp.left).offset(-10)
            make.height.width.equalTo(30)
        }
    }
    
}

extension USEWalletDetailTopCell {
    fileprivate func showAlterView(_ str : String){
        let hud = MBProgressHUD.showAdded(to: self.superview, animated: true)
        hud?.mode = .text
        hud?.detailsLabelText = str
        hud?.detailsLabelFont = UIFont.systemFont(ofSize: 16)
        hud?.margin = 10.0
        hud?.yOffset = -30
        hud?.removeFromSuperViewOnHide = true
        hud?.isUserInteractionEnabled = false
        hud?.hide(true, afterDelay: 0.5)
    }
}
