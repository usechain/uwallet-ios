//
//  USEKYCConfirmBtnCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/21.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

protocol USEKYCConfirmBtnCellBtnClicked: NSObjectProtocol {
    func clicked(btn: UIButton)
}

class USEKYCConfirmBtnCell: UITableViewCell {

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
    weak var delegate: USEKYCConfirmBtnCellBtnClicked?
    
     lazy var confirmBtn: UIButton = {
        let temp = UIButton(title: "确认提交", fontSize: 18, color: UIColor.white, imageName: nil, backColor: UIColor(red: 40/255, green: 113/255, blue: 251/255, alpha: 1.0))
        temp.layer.cornerRadius = 10
        temp.isHidden = true
        temp.addTarget(self, action: #selector(USEKYCConfirmBtnCell.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()

}

extension USEKYCConfirmBtnCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(confirmBtn)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.height.equalTo(40)
            make.width.equalTo(240)
        }
    }
}
