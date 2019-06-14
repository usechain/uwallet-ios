//
//  USETransferCompletedBtnCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/25.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit
protocol USETransferCompletedBtnCellBtnClicked: NSObjectProtocol {
    func clicked(btn: UIButton)
}
class USETransferCompletedBtnCell: UITableViewCell {
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
        delegate?.clicked(btn: btn)
    }
    weak var delegate: USETransferCompletedBtnCellBtnClicked?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var useChainBtn: UIButton = {
        let temp = UIButton(title: "到 Usechainscan 查询更多详细内容", fontSize: 14, color: UIColor(red: 34/255, green: 129/255, blue: 252/255, alpha: 1.0), imageName: nil, backColor: nil)
        temp.addTarget(self, action: #selector(USETransferCompletedBtnCell.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
}
extension USETransferCompletedBtnCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(useChainBtn)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        useChainBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
        }
    }
}
