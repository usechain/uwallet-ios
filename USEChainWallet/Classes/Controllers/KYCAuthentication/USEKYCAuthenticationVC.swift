
//
//  USEKYCAuthenticationVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/19.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit
import AVFoundation


class USEKYCAuthenticationVC: USEWalletBaseVC {
    
    @objc private func clicked(btn: UIButton) {
        switch btn.tag {
        case USEKYCAuthenticationVCBtnTag.pushNationPicker.rawValue:
            showNationPicker()
        case USEKYCAuthenticationVCBtnTag.selectLeftCardType.rawValue:
            if !cardTypeLeftBtn.isSelected {
                cardTypeLeftBtn.isSelected = true
                cardTypeRightBtn.isSelected = false
                // 切换图片录取
                UIView.animate(withDuration: 0.5) {
                    self.identifierCardFrontTitleLabel.text = "身份证正面照"
                    self.identidierCardFrontImageView.image = UIImage.init(named: "身份证正面")
                    self.identifierCardHoldTitleLabel.text = "手持身份证"
                    self.identifierCardBackTitleLabel.alpha = 1
                    self.identifierCardBackAddBtn.alpha = 1
                    self.identidierCardBackImageView.alpha = 1
                    self.identifierCardHoldTitleLabel.snp.remakeConstraints({ (make) in
                            make.top.equalTo(self.identidierCardFrontImageView.snp.bottom).offset(320)
                            make.left.equalTo(self.identifierCardFrontTitleLabel)
                    })
                    self.backScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 1500)
                   // self.view.layoutSubviews()
                    self.view.layoutIfNeeded()
                    self.view.setNeedsDisplay()
                    UserDefaults.standard.setValue(kIDCard, forKey: kKycCardType)
                }
            }
        case USEKYCAuthenticationVCBtnTag.selectRightCardType.rawValue:
            if !cardTypeRightBtn.isSelected {
                cardTypeLeftBtn.isSelected = false
                cardTypeRightBtn.isSelected = true
                UIView.animate(withDuration: 0.5) {
                    self.identifierCardFrontTitleLabel.text = "护照"
                    self.identidierCardFrontImageView.image = UIImage.init(named: "护照")
                    self.identifierCardHoldTitleLabel.text = "手持护照"
                    self.identifierCardBackTitleLabel.alpha = 0
                    self.identifierCardBackAddBtn.alpha = 0
                    self.identidierCardBackImageView.alpha = 0
                    self.identifierCardHoldTitleLabel.snp.makeConstraints({ (make) in
                        make.top.equalTo(self.identidierCardFrontImageView.snp.bottom).offset(40)
                        make.left.equalTo(self.identifierCardFrontTitleLabel)
                    })
                    self.backScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 1200)
                    self.view.layoutIfNeeded()
                    self.view.setNeedsDisplay()
                     UserDefaults.standard.setValue(kPassport, forKey: kKycCardType)
                }
            }
        case USEKYCAuthenticationVCBtnTag.nationPickerConfimClicked.rawValue:
            self.dissmissNationPicker()
            self.nationPickerLabel.text = self.nationPickerView.selectedCountryName
        case USEKYCAuthenticationVCBtnTag.nationPickerCancelClicked.rawValue:
            self.dissmissNationPicker()
        case USEKYCAuthenticationVCBtnTag.selectMale.rawValue:
                btn.isSelected  = !btn.isSelected
                if btn.isSelected {
                    sexRightBtn.isSelected = false
                }
        case USEKYCAuthenticationVCBtnTag.selectFemale.rawValue:
                btn.isSelected  = !btn.isSelected
                if btn.isSelected {
                    sexLeftBtn.isSelected = false
                }
        case USEKYCAuthenticationVCBtnTag.pushBirthPicker.rawValue:
            birthPicker()
        case USEKYCAuthenticationVCBtnTag.addFrontIDCard.rawValue:
            addIDCardImage(type: "front")
        case USEKYCAuthenticationVCBtnTag.addBackIDCard.rawValue :
            addIDCardImage(type: "back")
        case USEKYCAuthenticationVCBtnTag.addHoldIDCard.rawValue:
            addIDCardImage(type: "hold")
        case USEKYCAuthenticationVCBtnTag.nextStep.rawValue:
            nextStep()
        default:
            print("none Btn")
        }
    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "认证升级"
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        UserDefaults.standard.setValue(kIDCard, forKey: kKycCardType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UserDefaults.standard.setValue("", forKey: "currentIDCardType")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        backScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 1500)
    }
    
    // MARK: -Nation
    fileprivate lazy var backScrollView: UIScrollView = {
        let temp = UIScrollView()
        temp.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 1500)
        temp.backgroundColor = UIColor.white
        temp.delegate = self
        temp.isScrollEnabled = true
        temp.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return temp
    }()
    fileprivate lazy var nationLabel: UILabel = UILabel(title: "选择国家:", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var nationBackView: UIView = {
        let temp = UIView()
        temp.layer.cornerRadius = 5
        temp.layer.masksToBounds = true
        temp.layer.borderColor = UIColor.black.cgColor
        temp.layer.borderWidth = 1
        return temp
    }()
    fileprivate lazy var nationPickerBtn: UIButton = {
        let temp = UIButton(imageName: "nationDown", backImageName: nil)
        temp.tag = USEKYCAuthenticationVCBtnTag.pushNationPicker.rawValue
        temp.addTarget(self, action: #selector(USEKYCAuthenticationVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    fileprivate lazy var nationPickerLabel: UILabel = {
        let temp = UILabel(title: "中国", fontSize: 16, color: UIColor.black, redundance: 0)
        temp.isUserInteractionEnabled = true
        return temp
    }()
    fileprivate lazy var nationPickerView: CountryPicker = {
        let temp = CountryPicker()
        temp.backgroundColor = UIColor.white
        temp.delegate = self
        return temp
    }()
    fileprivate lazy var nationConfirmBtn: UIButton = {
        let temp = UIButton(title: "确认", fontSize: 16, color: UIColor.white, imageName: nil, backColor: UIColor(red: 11/255, green: 43/255, blue: 96/255, alpha: 1.0))
        temp.tag = USEKYCAuthenticationVCBtnTag.nationPickerConfimClicked.rawValue
        temp.addTarget(self, action:#selector(USEKYCAuthenticationVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        temp.isHidden = true

        return temp
    }()
    fileprivate lazy var nationCancelBtn: UIButton = {
        let temp = UIButton(title: "取消", fontSize: 16, color: UIColor.white, imageName: nil, backColor: UIColor(red: 11/255, green: 43/255, blue: 96/255, alpha: 1.0))
        temp.tag = USEKYCAuthenticationVCBtnTag.nationPickerCancelClicked.rawValue
        temp.addTarget(self, action: #selector(USEKYCAuthenticationVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        temp.isHidden = true
        return temp
    }()
        // MARK: -CardType
    fileprivate lazy var cardType: UILabel = UILabel(title: "证件类型:", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var cardTypeLeftBtn: UIButton = {
        let temp = UIButton(imageName: "user_zhuce1", backImageName: nil)
        temp.setImage(UIImage.init(named: "user_zhuce2"), for: UIControl.State.selected)
        temp.tag = USEKYCAuthenticationVCBtnTag.selectLeftCardType.rawValue
        temp.isSelected = true
        temp.addTarget(self, action: #selector(USEKYCAuthenticationVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    fileprivate lazy var cardTypeRightBtn: UIButton = {
        let temp = UIButton(imageName: "user_zhuce1", backImageName: nil)
        temp.setImage(UIImage.init(named: "user_zhuce2"), for: UIControl.State.selected)
        temp.tag = USEKYCAuthenticationVCBtnTag.selectRightCardType.rawValue
        temp.addTarget(self, action: #selector(USEKYCAuthenticationVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    fileprivate lazy var carTypeLeftLabel: UILabel = UILabel(title: "居民身份证", fontSize: 16, color: UIColor.black, redundance: 0)
    fileprivate lazy var cardTypeRightLabel: UILabel = UILabel(title: "国际护照", fontSize: 16, color: UIColor.black, redundance: 0)
    //name
    fileprivate lazy var nameTitleLabel: UILabel = UILabel(title: "姓名:", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var nameTextFiled: UITextField = {
        let temp = UITextField()
        temp.placeholder  = "请输入姓名"
        temp.delegate = self
        return temp
    }()
    fileprivate lazy var nameLine: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.black
        return temp
    }()
    // sex
    fileprivate lazy var sexTitleLabel: UILabel = UILabel(title: "性别:", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var sexLeftBtn: UIButton = {
        let temp = UIButton(imageName: "user_zhuce1", backImageName: nil)
        temp.setImage(UIImage.init(named: "user_zhuce2"), for: UIControl.State.selected)
        temp.tag = USEKYCAuthenticationVCBtnTag.selectMale.rawValue
        temp.addTarget(self, action: #selector(USEKYCAuthenticationVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    fileprivate lazy var sexMaleLabel: UILabel = UILabel(title: "男", fontSize: 16, color: UIColor.black, redundance: 0)
    fileprivate lazy var sexRightBtn: UIButton = {
        let temp = UIButton(imageName: "user_zhuce1", backImageName: nil)
        temp.setImage(UIImage.init(named: "user_zhuce2"), for: UIControl.State.selected)
        temp.tag = USEKYCAuthenticationVCBtnTag.selectFemale.rawValue
        temp.addTarget(self, action: #selector(USEKYCAuthenticationVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    fileprivate lazy var sexFemaleLabel: UILabel = UILabel(title: "女", fontSize: 16, color: UIColor.black, redundance: 0)
    fileprivate lazy var sexLine: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.black
        return temp
    }()
    //birthday
    fileprivate lazy var birthdayTitleLabel: UILabel = UILabel(title: "出生日期:", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var birthdayBackView: UIView = {
        let temp = UIView()
        temp.layer.cornerRadius = 5
        temp.layer.masksToBounds = true
        temp.layer.borderColor = UIColor.black.cgColor
        temp.layer.borderWidth = 1
        return temp
    }()
    fileprivate lazy var birthdayPickerBtn: UIButton = {
        let temp = UIButton(imageName: "nationDown", backImageName: nil)
        temp.tag = USEKYCAuthenticationVCBtnTag.pushBirthPicker.rawValue
        temp.addTarget(self, action: #selector(USEKYCAuthenticationVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    fileprivate lazy var birthdayPickerLabel: UILabel = {
        let temp = UILabel(title: "1992-11-11", fontSize: 16, color: UIColor.black, redundance: 0)
        temp.isUserInteractionEnabled = true
        return temp
    }()
    // cardNum
    fileprivate lazy var cardNumTitleLabel: UILabel = UILabel(title: "证件号码:", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var cardNumTextfield: UITextField = {
        let temp = UITextField()
        temp.placeholder  = "请输入证件号码"
        temp.delegate = self
        return temp
    }()
    fileprivate lazy var cardNumLine: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.black
        return temp
    }()
    // identifierCard
    fileprivate lazy var identifierCardFrontTitleLabel: UILabel = UILabel(title: "身份证正面照片:", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var identidierCardFrontImageView: UIImageView = {
        let temp = UIImageView(image: UIImage.init(named: "身份证正面"))
        temp.isUserInteractionEnabled = true
        return temp
    }()
    fileprivate lazy var identifierCardFrontAddBtn: UIButton = {
        let temp = UIButton(imageName: "u1676", backImageName: nil)
        temp.tag = USEKYCAuthenticationVCBtnTag.addFrontIDCard.rawValue
        temp.addTarget(self, action: #selector(USEKYCAuthenticationVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    fileprivate lazy var identifierCardBackTitleLabel: UILabel = UILabel(title: "身份证背面照片:", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var identidierCardBackImageView: UIImageView = {
        let temp = UIImageView(image: UIImage.init(named: "身份证反面"))
        temp.isUserInteractionEnabled = true
        return temp
    }()
    fileprivate lazy var identifierCardBackAddBtn: UIButton = {
        let temp = UIButton(imageName: "u1676", backImageName: nil)
        temp.tag = USEKYCAuthenticationVCBtnTag.addBackIDCard.rawValue
        temp.addTarget(self, action: #selector(USEKYCAuthenticationVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    fileprivate lazy var identifierCardHoldTitleLabel: UILabel = UILabel(title: "手持身份证照片:", fontSize: 18, color: UIColor.black, redundance: 0)
    fileprivate lazy var identidierCardHoldImageView: UIImageView = {
        let temp = UIImageView(image: UIImage.init(named: "手持身份证"))
        temp.isUserInteractionEnabled = true
        return temp
    }()
    fileprivate lazy var identifierCardHoldAddBtn: UIButton = {
        let temp = UIButton(imageName: "u1676", backImageName: nil)
        temp.tag = USEKYCAuthenticationVCBtnTag.addHoldIDCard.rawValue
        temp.addTarget(self, action: #selector(USEKYCAuthenticationVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        return temp
    }()
    fileprivate lazy var nextBtn: UIButton = {
        let temp = UIButton(title: "下一步", fontSize: 18, color: UIColor.white, imageName: nil, backColor: UIColor(red: 40/255, green: 113/255, blue: 251/255, alpha: 1.0))
        temp.tag = USEKYCAuthenticationVCBtnTag.nextStep.rawValue
        temp.addTarget(self, action: #selector(USEKYCAuthenticationVC.clicked(btn:)), for: UIControl.Event.touchUpInside)
        temp.layer.cornerRadius = 10
        return temp
    }()
    var textFiledRect: CGRect?
}

extension USEKYCAuthenticationVC {
    fileprivate func setupUI() {

        self.view.addSubview(backScrollView)
        backScrollView.addSubview(nationLabel)
        backScrollView.addSubview(nationBackView)
        nationBackView.addSubview(nationPickerLabel)
        nationBackView.addSubview(nationPickerBtn)
        
        backScrollView.addSubview(cardType)
        backScrollView.addSubview(cardTypeLeftBtn)
        backScrollView.addSubview(carTypeLeftLabel)
        backScrollView.addSubview(cardTypeRightBtn)
        backScrollView.addSubview(cardTypeRightLabel)
        //name
        backScrollView.addSubview(nameTitleLabel)
        backScrollView.addSubview(nameTextFiled)
        backScrollView.addSubview(nameLine)
        //sex
        backScrollView.addSubview(sexTitleLabel)
        backScrollView.addSubview(sexLeftBtn)
        backScrollView.addSubview(sexMaleLabel)
        backScrollView.addSubview(sexRightBtn)
        backScrollView.addSubview(sexFemaleLabel)
        backScrollView.addSubview(sexLine)
        //birthday
        backScrollView.addSubview(birthdayTitleLabel)
        backScrollView.addSubview(birthdayBackView)
        birthdayBackView.addSubview(birthdayPickerLabel)
        birthdayBackView.addSubview(birthdayPickerBtn)
        //cardnum
        backScrollView.addSubview(cardNumTitleLabel)
        backScrollView.addSubview(cardNumTextfield)
        backScrollView.addSubview(cardNumLine)
        //identifierCard
        backScrollView.addSubview(identifierCardFrontTitleLabel)
        backScrollView.addSubview(identidierCardFrontImageView)
    
        identidierCardFrontImageView.addSubview(identifierCardFrontAddBtn)
        
        backScrollView.addSubview(identifierCardBackTitleLabel)
        backScrollView.addSubview(identidierCardBackImageView)
        identidierCardBackImageView.addSubview(identifierCardBackAddBtn)
        
        backScrollView.addSubview(identifierCardHoldTitleLabel)
        backScrollView.addSubview(identidierCardHoldImageView)
        identidierCardHoldImageView.addSubview(identifierCardHoldAddBtn)

        backScrollView.addSubview(nationPickerView)
        backScrollView.addSubview(nationConfirmBtn)
        backScrollView.addSubview(nationCancelBtn)
        
        backScrollView.addSubview(nextBtn)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        backScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        nationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backScrollView).offset(20)
            make.left.equalTo(backScrollView).offset(20)
        }
        nationBackView.snp.makeConstraints { (make) in
            make.top.equalTo(nationLabel.snp.bottom).offset(10)
            make.left.equalTo(nationLabel)
            make.height.equalTo(30)
            make.width.equalTo(150)
        }
        nationPickerLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nationBackView)
            make.left.equalTo(nationBackView).offset(10)
        }
        nationPickerBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(nationBackView)
            make.right.equalTo(nationBackView.snp.right).offset(-5)
            make.height.equalTo(nationBackView)
            make.width.equalTo(20)
        }
        nationPickerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(0)
        }
        nationCancelBtn.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(UIScreen.main.bounds.size.width / 2)
            make.left.equalTo(self.backScrollView)
            make.bottom.equalTo(self.view).offset(0)
        }
        nationConfirmBtn.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(UIScreen.main.bounds.size.width / 2)
            make.right.equalTo(nationPickerView)
            make.bottom.equalTo(self.view).offset(0)
        }
        cardType.snp.makeConstraints { (make) in
            make.left.equalTo(nationBackView)
            make.top.equalTo(nationBackView.snp.bottom).offset(20)
        }
        cardTypeLeftBtn.snp.makeConstraints { (make) in
            make.top.equalTo(cardType.snp.bottom).offset(10)
            make.left.equalTo(cardType)
            make.height.width.equalTo(30)
        }
        carTypeLeftLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(cardTypeLeftBtn)
            make.left.equalTo(cardTypeLeftBtn.snp.right).offset(5)
        }
        cardTypeRightBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(carTypeLeftLabel)
            make.left.equalTo(carTypeLeftLabel.snp.right).offset(40)
            make.height.width.equalTo(30)
        }
        cardTypeRightLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(cardTypeRightBtn)
            make.left.equalTo(cardTypeRightBtn.snp.right).offset(5)
        }
        nameTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cardTypeLeftBtn.snp.bottom).offset(20)
            make.left.equalTo(cardTypeLeftBtn)
        }
        nameTextFiled.snp.makeConstraints { (make) in
            make.left.equalTo(nameTitleLabel)
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(10)
            make.right.equalTo(backScrollView.snp.right).offset(-20)
        }
        nameLine.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextFiled.snp.bottom).offset(1)
            make.left.equalTo(nameTextFiled)
            make.height.equalTo(1)
            make.right.equalTo(self.view.snp.right).offset(-20)
        }
        sexTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLine.snp.bottom).offset(20)
            make.left.equalTo(nameLine)
        }
        sexLeftBtn.snp.makeConstraints { (make) in
            make.top.equalTo(sexTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(sexTitleLabel)
            make.width.height.equalTo(30)
        }
        sexMaleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sexLeftBtn.snp.right).offset(5)
            make.centerY.equalTo(sexLeftBtn)
        }
        sexRightBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(sexMaleLabel)
            make.left.equalTo(cardTypeRightBtn)
            make.height.width.equalTo(30)
        }
        sexFemaleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(sexRightBtn)
            make.left.equalTo(sexRightBtn.snp.right).offset(5)
        }
        sexLine.snp.makeConstraints { (make) in
            make.left.equalTo(sexLeftBtn)
            make.height.equalTo(1)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(sexFemaleLabel.snp.bottom).offset(5)
        }
        birthdayTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sexLine.snp.bottom).offset(40)
            make.left.equalTo(sexLine)
        }
        birthdayBackView.snp.makeConstraints { (make) in
            make.top.equalTo(birthdayTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(birthdayTitleLabel.snp.left)
            make.height.equalTo(30)
            make.width.equalTo(150)
        }
        birthdayPickerLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(birthdayBackView)
            make.left.equalTo(birthdayBackView).offset(10)
        }
        birthdayPickerBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(birthdayBackView)
            make.right.equalTo(birthdayBackView.snp.right).offset(-5)
            make.height.equalTo(birthdayBackView)
            make.width.equalTo(20)
        }

        cardNumTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(birthdayBackView.snp.bottom).offset(30)
            make.left.equalTo(birthdayBackView)
        }
        cardNumTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(cardNumTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(cardNumTitleLabel)
            make.height.equalTo(20)
            make.right.equalTo(nameTextFiled)
        }
        cardNumLine.snp.makeConstraints { (make) in
            make.top.equalTo(cardNumTextfield.snp.bottom).offset(2)
            make.left.equalTo(cardNumTextfield)
            make.right.equalTo(sexLine)
            make.height.equalTo(1)
        }
        identifierCardFrontTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cardNumLine.snp.bottom).offset(40)
            make.left.equalTo(cardNumLine)
        }
        identidierCardFrontImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(backScrollView)
            make.top.equalTo(identifierCardFrontTitleLabel.snp.bottom).offset(20)
            make.left.equalTo(backScrollView).offset(40)
            make.right.equalTo(backScrollView).offset(-40)
            make.height.equalTo(200)
        }
        identifierCardFrontAddBtn.snp.makeConstraints { (make) in
            make.center.equalTo(identidierCardFrontImageView)
            make.height.width.equalTo(40)
        }
        identifierCardBackTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(identidierCardFrontImageView.snp.bottom).offset(40)
            make.left.equalTo(identifierCardFrontTitleLabel)
        }
        identidierCardBackImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(backScrollView)
            make.top.equalTo(identifierCardBackTitleLabel.snp.bottom).offset(20)
            make.left.equalTo(backScrollView).offset(40)
            make.right.equalTo(backScrollView).offset(-40)
            make.height.equalTo(200)
        }
        identifierCardBackAddBtn.snp.makeConstraints { (make) in
            make.center.equalTo(identidierCardBackImageView)
            make.height.width.equalTo(40)
        }
        identifierCardHoldTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(identidierCardBackImageView.snp.bottom).offset(40)
            make.left.equalTo(identifierCardBackTitleLabel)
        }
        identidierCardHoldImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(backScrollView)
            make.top.equalTo(identifierCardHoldTitleLabel.snp.bottom).offset(20)
            make.left.equalTo(backScrollView).offset(40)
            make.right.equalTo(backScrollView).offset(-40)
            make.height.equalTo(200)
        }
        identifierCardHoldAddBtn.snp.makeConstraints { (make) in
            make.center.equalTo(identidierCardHoldImageView)
            make.height.width.equalTo(40)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(backScrollView)
            make.top.equalTo(identidierCardHoldImageView.snp.bottom).offset(50)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
    }
}

extension USEKYCAuthenticationVC:CountryPickerDelegate {
    func countryPicker(_ picker: CountryPicker!, didSelectCountryWithName name: String!, code: String!) {
        nationPickerLabel.text = name
    }
}

extension USEKYCAuthenticationVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            self.dissmissNationPicker()
    }
}

extension USEKYCAuthenticationVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let currentImage = UserDefaults.standard.value(forKey: "currentIDCardType") as! String
        if currentImage == "front" {
            identidierCardFrontImageView.image = UIImage(data: UIImage.reSizeImageData(pickedImage, maxImageSize: 400, maxSizeWithKB: 256))
        } else if currentImage == "back" {
            identidierCardBackImageView.image = UIImage(data: UIImage.reSizeImageData(pickedImage, maxImageSize: 400, maxSizeWithKB: 256))
        } else if currentImage == "hold" {
            identidierCardHoldImageView.image = UIImage(data: UIImage.reSizeImageData(pickedImage, maxImageSize: 400, maxSizeWithKB: 256))
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension USEKYCAuthenticationVC: UIActionSheetDelegate {
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
        } else {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            if buttonIndex == 1 {
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                imagePickerController.cameraDevice = UIImagePickerController.CameraDevice.rear
            } else {
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary;
            }
            self.navigationController?.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
}

extension USEKYCAuthenticationVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let window = UIApplication.shared.delegate?.window
        let rect = textField.convert(textField.bounds, to: window!)
        textFiledRect = rect
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    @objc func keyBoardWillShow(_ notification:Notification){
        weak var weakSelf = self
        DispatchQueue.main.async {
            let user_info = notification.userInfo
            let keyboardRect = (user_info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            print(keyboardRect)
            let yValueBetween2Rect = weakSelf!.textFiledRect!.maxY - keyboardRect.minY + 10
            if yValueBetween2Rect < 0 {
                return
            } else {
                weakSelf?.backScrollView.setContentOffset(CGPoint(x: weakSelf!.backScrollView.contentOffset.x, y: weakSelf!.backScrollView.contentOffset.y + yValueBetween2Rect), animated: true)
            }
        }
    }
}

extension USEKYCAuthenticationVC {
    
    fileprivate func nextStep() {
        let cardType = UserDefaults.standard.value(forKey: kKycCardType) as! String
        let accountInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
        let KYCUserKey = "KYCUserInfo" + ((accountInfo?.last!)!)
        var userInfo =  ["name": "", "sex": "", "id": "", "certtype": "", "nation": "", "birthday": "", "addr": "", "ename": ""]
        UserDefaults.standard.setValue(userInfo, forKey: KYCUserKey)
        userInfo["nation"] = nationPickerLabel.text
        if nameTextFiled.text == "" {
            showAlterView("请输入姓名", mySelf: self)
            return
        }
        userInfo["name"] = nameTextFiled.text
        if (sexLeftBtn.isSelected == false) && (sexRightBtn.isSelected == false) {
            showAlterView("请选择性别", mySelf: self)
            return
        }
        if sexLeftBtn.isSelected == true {
            userInfo["sex"] = "1"
        } else {
            userInfo["sex"] = "2"
        }
        if cardType  == kIDCard {
            userInfo["certtype"] = "1"
        } else {
            userInfo["certtype"] = "2"
        }

        userInfo["birthday"] = birthdayPickerLabel.text
        if cardNumTextfield.text == "" {
            showAlterView("请输入证件号", mySelf: self)
            return
        }
        userInfo["id"] = cardNumTextfield.text
        UserDefaults.standard.setValue(userInfo, forKey: KYCUserKey)
        if cardType == kIDCard {
            let frontSourceImage = UIImage.init(named: "身份证正面")
            let frontSourceImageData = UIImage.pngData(frontSourceImage!)
            let frontNowImageData = UIImage.pngData(identidierCardFrontImageView.image!)
            if frontSourceImageData()?.base64EncodedString() == frontNowImageData()?.base64EncodedString() {
                showAlterView("请添加身份证正面照", mySelf: self)
                return
            }
            let backSourceImage = UIImage.init(named: "身份证反面")
            let backSourceImageData = UIImage.pngData(backSourceImage!)
            let backNowImageData = UIImage.pngData(identidierCardBackImageView.image!)
            if backSourceImageData()?.base64EncodedString() == backNowImageData()?.base64EncodedString() {
                showAlterView("请添加身份证背面照", mySelf: self)
                return
            }
            let holdSourceImage = UIImage.init(named: "手持身份证")
            let holdSourceImageData = UIImage.pngData(holdSourceImage!)
            let holdNowImageData = UIImage.pngData(identidierCardHoldImageView.image!)
            if holdSourceImageData()?.base64EncodedString() == holdNowImageData()?.base64EncodedString() {
                showAlterView("请添加手持身份证照", mySelf: self)
                return
            }
            USEStoreTools.saveImage(with: identidierCardFrontImageView.image!, andName: "frontImage")
            USEStoreTools.saveImage(with: identidierCardBackImageView.image!, andName: "BackImage")
            USEStoreTools.saveImage(with: identidierCardHoldImageView.image!, andName: "HoldImage")
        } else {
            let frontSourceImage = UIImage.init(named: "护照")
            let frontSourceImageData = UIImage.pngData(frontSourceImage!)
            let frontNowImageData = UIImage.pngData(identidierCardFrontImageView.image!)
            if frontSourceImageData()?.base64EncodedString() == frontNowImageData()?.base64EncodedString() {
                showAlterView("请添加护照", mySelf: self)
                return
            }
            let holdSourceImage = UIImage.init(named: "手持身份证")
            let holdSourceImageData = UIImage.pngData(holdSourceImage!)
            let holdNowImageData = UIImage.pngData(identidierCardHoldImageView.image!)
            if holdSourceImageData()?.base64EncodedString() == holdNowImageData()?.base64EncodedString() {
                showAlterView("请添加手持护照", mySelf: self)
                return
            }
            USEStoreTools.saveImage(with: identidierCardFrontImageView.image!, andName: "frontImage")
            USEStoreTools.saveImage(with: identidierCardHoldImageView.image!, andName: "HoldImage")
        }
        self.navigationController?.pushViewController(USEKYCConfirmVC(), animated: true)
    }
    
    fileprivate func addIDCardImage(type: String) {
        
        if USEAVCaptureTools.checkScanPermissions(mySelf: self) {
            UserDefaults.standard.setValue(type, forKey: "currentIDCardType")
            let sheet = UIActionSheet(title: "选择图片源", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "相册")
            sheet.show(in: self.view)
        } else {
            USEAVCaptureTools.requestForAVCaptureAuthorization { (result) in
            }
        }
    }
    
    fileprivate func birthPicker() {
        let temp = CXDatePickerView(dateStyle: CXDateStyle.showYearMonthDay, complete: { (selectData) in
            print("时间赋值")
            let myFormatter = DateFormatter()
            myFormatter.dateFormat = "yyyy-MM-dd"
            myFormatter.string(from: selectData!)
            self.birthdayPickerLabel.text = myFormatter.string(from: selectData!)
        })
        temp?.dateLabelColor = UIColor.black
        temp?.datePickerColor = UIColor.red
        temp?.doneButtonColor = UIColor.orange
        temp?.cancelButtonColor = UIColor.orange
        temp?.show()
    }
    
    fileprivate func showNationPicker() {
        UIView.animate(withDuration: 0.2) {
            self.nationPickerView.snp.updateConstraints { (make) in
                make.height.equalTo(300)
            }
            self.nationCancelBtn.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view).offset(-300)
            })
            self.nationConfirmBtn.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view).offset(-300)
            })
            self.nationConfirmBtn.isHidden = false
            self.nationCancelBtn.isHidden = false
            self.backScrollView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func dissmissNationPicker() {
        nationConfirmBtn.isHidden = true
        nationCancelBtn.isHidden = true
        UIView.animate(withDuration: 0.25) {
            self.nationPickerView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            self.nationConfirmBtn.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.view).offset(0)
            }
            self.nationCancelBtn.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.view).offset(0)
            }
            self.backScrollView.backgroundColor = UIColor.white
            self.view.layoutIfNeeded()
        }
    }
}
