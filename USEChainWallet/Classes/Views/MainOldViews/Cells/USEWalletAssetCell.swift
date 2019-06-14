//
//  USEWalletAssetCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/1.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEWalletAssetCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: -LazyloadKit
    fileprivate lazy var leftImage: UIImageView = UIImageView(image: UIImage.init(named: "u47"))
    fileprivate lazy var title: UILabel = UILabel(title: "USE", fontSize: 20, color: UIColor(red: 0/255, green: 114/255, blue: 213/255, alpha: 1.0), redundance: 0)
    lazy var coinCount: UILabel = UILabel(title: "3,000.1231231", fontSize: 14, color: UIColor(red: 0/255, green: 114/255, blue: 213/255, alpha: 1.0), redundance: 0)
    lazy var estimateRMB: UILabel = UILabel(title: "≈ ¥0", fontSize: 12, color: UIColor.gray, redundance: 0)
}
extension USEWalletAssetCell {
    fileprivate func setupUI() {
        // addSubviews
        self.contentView.addSubview(leftImage)
        self.contentView.addSubview(title)
        self.contentView.addSubview(coinCount)
        self.contentView.addSubview(estimateRMB)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        // layout
        leftImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(30)
            make.height.width.equalTo(30)
        }
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(leftImage.snp.right).offset(10)
        }
        coinCount.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-30)
        }
        estimateRMB.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView).offset(-10)
            make.right.equalTo(self.contentView).offset(-30)
        }
    }
}
