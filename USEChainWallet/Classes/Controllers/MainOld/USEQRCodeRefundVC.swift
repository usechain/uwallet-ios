
//
//  USEQRCodeRefundVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/22.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEQRCodeRefundVC: USEWalletBaseVC {
    
    @objc fileprivate func clicked(btn: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = addressLabel.text
        showAlterView("地址复制成功", mySelf: self)
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "收款码"
        self.view.backgroundColor = UIColor.white
        let address = (UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as! Array<String>).last
        let UMAddressPubKey = kUmPublickKeyHalf + (address?.lowercased())!
        let umAddress = UseChainNetTools.getUMAddressWith(publicKey: UserDefaults.standard.value(forKey: UMAddressPubKey) as! NSString)
        addressLabel.text = umAddress as String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
 
    fileprivate lazy var addressLabel: UILabel = UILabel(title: "aosidhasaidbfisubfuiqwhriueh3298sadsadasdasdasdasd4yiuehfibsbgisbgiwe3984yuih", fontSize: 14, color: UIColor.black, redundance: 60)
    fileprivate lazy var copyBtn: UIButton = {
        let temp = UIButton(title: "复制", fontSize: 18, color: UIColor.white, imageName: nil, backColor: UIColor(red: 55/255, green: 140/255, blue: 248/255, alpha: 1.0))
        temp.addTarget(self, action: #selector(USEQRCodeRefundVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        temp.layer.cornerRadius = 10
        return temp
    }()
    fileprivate lazy var bottomLaebl: UILabel = UILabel(title: "提示:请勿转账非Usechain链上的资产至当前钱包地址", fontSize: 14, color: UIColor.red, redundance: 60)
    fileprivate lazy var qrCodeImageView: UIImageView = {
        let temp = UIImageView(image: UIImage(named: "二维码"))
        temp.backgroundColor = UIColor.green
        let address = (UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as! Array<String>).last
        let UMAddressPubKey = kUmPublickKeyHalf + (address?.lowercased())!
        let umAddress = UseChainNetTools.getUMAddressWith(publicKey: UserDefaults.standard.value(forKey: UMAddressPubKey) as! NSString)
        temp.image =         UIImage.createNonInterpolatedUIImageForm(UIImage.generateQrcode(umAddress).ciImage!, withSize: CGFloat(200))
            temp.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(actionBlock: { (action) in
                UIImageWriteToSavedPhotosAlbum(temp.image!, nil, nil, nil);
                showAlterView("保存二维码成功", mySelf: self)
            })
            temp.addGestureRecognizer(gesture)
        return temp
    }()
    
}

extension USEQRCodeRefundVC {
    
    fileprivate func setupUI() {
        self.view.addSubview(addressLabel)
        self.view.addSubview(qrCodeImageView)
        self.view.addSubview(copyBtn)
        self.view.addSubview(bottomLaebl)
        
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        qrCodeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(qrCodeImageView.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
        }
        copyBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(addressLabel.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        bottomLaebl.snp.makeConstraints { (make) in
            make.top.equalTo(copyBtn.snp.bottom).offset(40)
            make.centerX.equalTo(self.view)
        }
    }
    
}
