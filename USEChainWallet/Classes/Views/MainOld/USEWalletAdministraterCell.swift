//
//  USEWalletAdministraterCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/19.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

protocol USEWalletAdministraterCellBtnClicked: NSObjectProtocol {
    func clicked(btn: UIButton)
}

class USEWalletAdministraterCell: UITableViewCell {
    @objc fileprivate func clickedBtn(btn: UIButton) {
//        UserDefaults.standard.setValue([walletNameArray?[indexPath.row]["walletName"], walletStoreArray?[indexPath.row]["walletStore"], walletAddressArray?[indexPath.row]["walletAddress"]], forKey: USECurrentAccountInfo)
        let classicAddress = UseChainNetTools.recoverToNormalAddress(umAddress: (addressLabel.text)!).dropHexPrefix
        
      //  let removePrefixAddress = addressLabel.text?.withoutHex
        UserDefaults.standard.setValue([nameLabel.text, walletStore, classicAddress], forKey: kUSECurrentAccountInfo)
        UserDefaults.standard.synchronize()
        delegate?.clicked(btn: btn)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    weak var delegate: USEWalletAdministraterCellBtnClicked?
    fileprivate lazy var backView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.white
        temp.layer.cornerRadius = 10
        return temp
    }()
     lazy var nameLabel: UILabel = {
        let temp = UILabel(title: "小优的钱包", fontSize: 16, color: UIColor(hexString: "333333") ?? UIColor.black, redundance: 0)
        return temp
    }()
     lazy var addressLabel: UILabel = {
        let temp = UILabel(title: "0xffDBFf3...B23D229", fontSize: 12, color: UIColor(hexString: "666666") ?? UIColor.black, redundance: 0)
        return temp
    }()
    lazy var walletStore: String = {
        let temp = ""
        return temp
    }()
    fileprivate lazy var rightBtn: UIButton = {
        let temp = UIButton(title: "", color: UIColor.black, backImageName:  "right")
        temp.addTarget(self, action: #selector(USEWalletAdministraterCell.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
     //   temp.backgroundColor = UIColor.red
        return temp
    }()
    
}

extension USEWalletAdministraterCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(backView)
        backView.addSubview(nameLabel)
        backView.addSubview(addressLabel)
        backView.addSubview(rightBtn)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        backView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.contentView).offset(10)
            make.bottom.right.equalTo(self.contentView).offset(-10)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backView).offset(12)
            make.left.equalTo(backView).offset(20)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(backView).offset(-12)
            make.left.equalTo(nameLabel)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(backView)
            make.right.equalTo(backView.snp.right).offset(-20)
//            make.height.width.equalTo(30)
        }
    }
}
