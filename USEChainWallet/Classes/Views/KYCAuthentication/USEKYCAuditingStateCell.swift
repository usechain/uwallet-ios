//
//  USEKYCAuditingStateCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/21.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEKYCAuditingStateCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.selectionStyle = .none
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var auditingLabel: UILabel = {
        let temp = UILabel(title: "", fontSize: 30, color: UIColor(red: 40/255, green: 113/255, blue: 251/255, alpha: 1.0), redundance: 0)
        return temp
    }()
}

extension USEKYCAuditingStateCell {
    fileprivate func setupUI(){
        self.contentView.addSubview(auditingLabel)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        auditingLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
        }
    }
}
