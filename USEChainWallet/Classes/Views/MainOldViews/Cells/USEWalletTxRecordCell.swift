//
//  USEWalletTxRecordCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/1.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEWalletTxRecordCell: UITableViewCell {

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
    lazy var address: UILabel = UILabel(title: "0xasdfeasd.....SADWAew123", fontSize: 15, color: UIColor.black, redundance: 0)
    lazy var date: UILabel = UILabel(title: "02-23-2019 22:10:29", fontSize: 12, color: UIColor.gray, redundance: 0)
    lazy var count: UILabel = UILabel(title: "+3,500.123123", fontSize: 18, color: UIColor.black, redundance: 0)
    var model: USETxRecordModel? {
        didSet {
            let resultBalance = model!.txValue
            let bigNumResultBalance = BigNumber(decimalString: resultBalance)
            let balanceStr = Payment.formatEther(bigNumResultBalance, options: (EtherFormatOption.commify.rawValue | EtherFormatOption.approximate.rawValue))
            let umAddress = kGetCurrentAccountUMAdderss()
            if model!.txFrom?.lowercased() == umAddress.lowercased() {
                // 转出
                address.text = model!.txTo?.ellipsisMiddleSting
                count.text = "-" + balanceStr!
            } else {
                // 转入
                address.text = model!.txFrom?.ellipsisMiddleSting
                count.text = "+" + balanceStr!
            }
            let tempDate = Date.init(timeIntervalSince1970: Double(truncating: (model?.blockTimeStamp)!))
            date.text = NSDate.timeStampToStandardTime(date: tempDate, format: "YYYY-MM-dd HH:mm:ss")
        }
    }
    
}

extension USEWalletTxRecordCell {
    fileprivate func setupUI() {
        // addSubviews
        self.contentView.addSubview(address)
        self.contentView.addSubview(date)
        self.contentView.addSubview(count)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        // layout
        address.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(10)
        }
        date.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
        count.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-10)
        }
    }
}
