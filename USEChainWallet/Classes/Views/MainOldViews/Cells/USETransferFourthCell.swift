//
//  USETransferFourthCell.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/25.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USETransferFourthCell: UITableViewCell {

    @objc fileprivate func sliderValueChanged() {
        let result = 100000000000 * minerFeeSlider.value / 1000000000
        gasCostLabel.text = "\(result)" + "uhui"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var addtionDataTF: UITextField = {
        let temp = UITextField()
        temp.placeholder = "备注(选填)"
        return temp
    }()
    fileprivate lazy var minerFeeLabel: UILabel = UILabel(title: "矿工费用:", fontSize: 14, color: UIColor.black, redundance: 0)
    lazy var minerFee: UILabel = UILabel(title: "1USE ≈ ¥", fontSize: 14, color: UIColor.black, redundance: 0)
    fileprivate lazy var lowerImageView: UIImageView = {
        let temp = UIImageView()
        temp.image = UIImage.init(named: "tortoise")
        return temp
    }()
    fileprivate lazy var fasterImageView: UIImageView = {
        let temp = UIImageView()
        temp.image = UIImage.init(named: "rabbit")
        return temp
    }()
    lazy var minerFeeSlider: UISlider = {
        let temp = UISlider()
        temp.addTarget(self, action: #selector(USETransferFourthCell.sliderValueChanged), for: UIControl.Event.valueChanged)
        
        return temp
    }()
    fileprivate lazy var gasCostLabel: UILabel = UILabel(title: "0.0uhui", fontSize: 14, color: UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0), redundance: 0)
}
extension USETransferFourthCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(addtionDataTF)
        self.contentView.addSubview(minerFeeLabel)
        self.contentView.addSubview(minerFee)
        self.contentView.addSubview(lowerImageView)
        self.contentView.addSubview(fasterImageView)
        self.contentView.addSubview(minerFeeSlider)
        self.contentView.addSubview(gasCostLabel)
        for v in self.contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        addtionDataTF.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(30)
            make.left.equalTo(self.contentView).offset(15)
        }
        minerFeeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addtionDataTF.snp.bottom).offset(10)
            make.left.equalTo(addtionDataTF)
        }
        minerFee.snp.makeConstraints { (make) in
            make.top.equalTo(minerFeeLabel)
            make.right.equalTo(self.contentView.snp.right).offset(-15)
        }
        lowerImageView.snp.makeConstraints { (make) in
            make.top.equalTo(minerFeeLabel.snp.bottom).offset(15)
            make.left.equalTo(minerFeeLabel)
            make.height.width.equalTo(40)
        }
        fasterImageView.snp.makeConstraints { (make) in
            make.top.equalTo(lowerImageView)
            make.right.equalTo(self.contentView.snp.right).offset(-15)
            make.width.height.equalTo(40)
        }
        minerFeeSlider.snp.makeConstraints { (make) in
            make.centerY.equalTo(lowerImageView)
            make.centerX.equalTo(self.contentView)
            make.left.equalTo(lowerImageView.snp.right).offset(10)
            make.right.equalTo(fasterImageView.snp.left).offset(-10)
        }
        gasCostLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(minerFeeSlider.snp.bottom).offset(30)
        }
    }
}
