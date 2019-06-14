//
//  USEKYCCAChooseCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/4/1.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

protocol USEKYCCAChooseCellBtnClicked: NSObjectProtocol {
    func clicked(btn: UIButton)
}

class USEKYCCAChooseCell: UITableViewCell {
    
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
    weak var delegate: USEKYCCAChooseCellBtnClicked?
     lazy var leftBtn: UIButton = {
        let btn = UIButton(imageName: "user_zhuce1", backImageName: nil)
        btn.addTarget(self, action: #selector(USEKYCCAChooseCell.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        btn.setImage(UIImage.init(named: "user_zhuce2"), for: UIControl.State.selected)
        return btn
    }()
    lazy var rightLabel: UILabel = UILabel(title: "Usechain CA认证中心", fontSize: 16, color: UIColor.black, redundance: 0)
}
extension USEKYCCAChooseCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(leftBtn)
        self.contentView.addSubview(rightLabel)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        leftBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(20)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            //make.centerX.equalTo(self.contentView)
            make.left.equalTo(leftBtn.snp.right).offset(20)
        }
    }
}
