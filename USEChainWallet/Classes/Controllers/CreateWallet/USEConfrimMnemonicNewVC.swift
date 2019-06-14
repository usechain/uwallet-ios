//
//  USEConfrimMnemonicNewVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/28.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit
import TangramKit

var selectedCount: Int = 0
var correctSelectIndex: Int = 0
class USEConfrimMnemonicNewVC: USEWalletBaseVC {
    
    @objc private func clickedBtn(btn: UIButton) {
        if btn.tag == 12 {
            if correctSelectIndex != 12 {
                showAlterView("请按顺序选择全部助记词", mySelf: self)
                return
            }
            // 确认 应该就换回了吧 pop到首页 要确认一下
            let menmonicString = UserDefaults.standard.value(forKey: "USEUserWalletMnemonic") as! String
            if UserDefaults.standard.value(forKey: "USEUserWallets") != nil {
                var walletsArray = UserDefaults.standard.value(forKey: "USEUserWallets") as! Array<String>
                for i in walletsArray {
                    if menmonicString == i {
                        showAlterView("钱包已存在", mySelf: self)
                        return
                    }
                }
                walletsArray.append(menmonicString)
                UserDefaults.standard .setValue(walletsArray, forKey: "USEUserWallets")
            } else {
                var walletsArray = Array<String>()
                walletsArray.append(menmonicString)
                UserDefaults.standard .setValue(walletsArray, forKey: "USEUserWallets")
            }
            UserDefaults.standard.setValue([UserDefaults.standard.value(forKey: "USEUserWalletName"), UserDefaults.standard.value(forKey: "USEUserWalletPasscode")], forKey: UserDefaults.standard.value(forKey: "USEUserWalletMnemonic") as! String)
            // 拿一下当前钱包的地址
            let currentAddress = UseEthersManager(mnemonicPhrase: UserDefaults.standard.value(forKey: "USEUserWalletMnemonic") as? String, slot: 0)?.address.data.toHexString()
            // 在这存一下当前钱包的publickKey
            let account: Account = UseEthersManager(mnemonicPhrase: menmonicString, slot: 0)
            let currentPubKey = UseChainNetTools.getPubkeyWith(account: account)
            let  UmPublickKey = kUmPublickKeyHalf + currentAddress!
            
            UserDefaults.standard.setValue(currentPubKey, forKey: UmPublickKey)

            UserDefaults.standard.setValue([UserDefaults.standard.value(forKey: "USEUserWalletName"), UserDefaults.standard.value(forKey: "USEUserWalletMnemonic"), currentAddress], forKey: kUSECurrentAccountInfo)
            self.navigationController?.pushViewController(USEWalletMainOldVC(), animated: true)
            return
            
        }
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            btn.backgroundColor = UIColor(hexString: "3289fc")
        } else {
            btn.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        }
        if btn.tag != 12 {
            if btn.isSelected {
                userSlecteIndexArray.append(btn.tag)
                print(userSlecteIndexArray)
            } else {
                for i in 0..<userSlecteIndexArray.count {
                    if btn.tag == userSlecteIndexArray[i] {
                        userSlecteIndexArray.remove(at: i)
                        return
                    }
                }
                print(userSlecteIndexArray)
            }
        }
        if btn.titleLabel!.text == " \(correctWordsArray[correctSelectIndex]) " {
            if userSlecteIndexArray.count - 1 != correctSelectIndex {
                return
            }
            correctSelectIndex = correctSelectIndex + 1
            let mnemonicLabel = UILabel(title: btn.titleLabel?.text ?? "" , fontSize: 15, color: UIColor(hexString: "333333") ?? UIColor.black, redundance: 0)
            let backView = UIView()
            backView.tg_height.equal((UIScreen.main.bounds.size.width - 30) / 7)
            backView.tg_width.equal((UIScreen.main.bounds.size.width - 30) / 4)
            mnemonicView.addSubview(backView)
            backView.addSubview(mnemonicLabel)
            mnemonicLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(backView)
                make.centerX.equalTo(backView)
            }
            btn.isEnabled = false
        } else {
            showAlterView("助记词顺序错误", mySelf: self)
        }
    }
    
    override func loadView() {
        super.loadView()
        userSlecteIndexArray = []
        correctSlecteIndexArray = []
        sixRandomWordsArray = []
        twelveRandomWordsArray = []
        correctWordsArray = []
        correctSelectIndex = 0
        seupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "确认助记词"
        correctSelectIndex = 0
        for i in correctWordsArray {
            if sixRandomWordsArray.contains(i) {
                for (index, value) in twelveRandomWordsArray.enumerated() {
                    if i == value {
                        correctSlecteIndexArray.append(index)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        correctSelectIndex = 0
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        correctSelectIndex = 0
        userSlecteIndexArray = []
        correctSlecteIndexArray = []
        sixRandomWordsArray = []
        twelveRandomWordsArray = []
        correctWordsArray = []
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    // MARK: -lazyload kit
    fileprivate var userSlecteIndexArray:Array<Int> = []
    fileprivate var correctSlecteIndexArray:Array<Int> = []
    
    fileprivate var sixRandomWordsArray:Array<String> = []
    fileprivate var twelveRandomWordsArray:Array<String> = []
    
    fileprivate var correctWordsArray:Array<String> = []
    fileprivate lazy var topBackView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor(hexString: "f2f2f2")
        return tempView
    }()
    fileprivate lazy var topWarningPointLabel: UILabel =  UILabel(title: "•", fontSize: 16, color: UIColor(hexString: "f60b0b") ?? UIColor.red, redundance: 0)
    fileprivate lazy var topWarningLabel: UILabel = UILabel(title: "请根据您记下的助记词，按顺序点击，验证您备份的助记词正确无误", fontSize: 12, color: UIColor(hexString: "f60b0b") ?? UIColor.black, redundance: 2)
    
    //
    fileprivate lazy var mnemonicView: TGFlowLayout = {
        let menmonicString = UserDefaults.standard.value(forKey: "USEUserWalletMnemonic") as! String
        let mnemonicArray: [String] = menmonicString.components(separatedBy: " ")
        correctWordsArray = mnemonicArray
        let S = TGFlowLayout(.vert,arrangedCount:4)
        S.tg_height.equal(.wrap)
        S.tg_padding = UIEdgeInsets(top: 2,left: 2,bottom: 2,right: 2)
        S.tg_space = 2
        S.backgroundColor = UIColor(hexString: "f2f2f2")
        S.layer.cornerRadius = 5
        return S
    }()
    
    fileprivate lazy var mnemonicBtnView: TGFlowLayout = {
        let menmonicString = UserDefaults.standard.value(forKey: "USEUserWalletMnemonic") as! String
        let mnemonicArray = menmonicString.components(separatedBy: " ")
        var randomArray: Array<String> = []
        for i in Random.number(end: 12) {
            randomArray.append(mnemonicArray[i-1])
        }
        let S = TGFlowLayout(.vert,arrangedCount:4)
        S.tg_height.equal(.wrap)
        S.tg_padding = UIEdgeInsets(top: 2,left: 2,bottom: 2,right: 2)
        S.tg_space = 2
        for i in 0 ..< 12
        {
            twelveRandomWordsArray.append(randomArray[i])
            let tempLinkStr = " " + randomArray[i] + " "
            let mnemonicBtn = UIButton(title: tempLinkStr, fontSize: 15, color: UIColor(hexString: "333333") ?? UIColor.black, imageName: nil, backColor: UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0))
            mnemonicBtn.tag = i
            mnemonicBtn.addTarget(self, action: #selector(USEConfrimMnemonicNewVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
            let backView = UIView()
            backView.tg_height.equal((UIScreen.main.bounds.size.width - 30) / 7)
            backView.tg_width.equal((UIScreen.main.bounds.size.width - 30) / 4)
            S.addSubview(backView)
            backView.addSubview(mnemonicBtn)
            mnemonicBtn.snp.makeConstraints { (make) in
                make.centerY.equalTo(backView)
                make.centerX.equalTo(backView)
            }
        }
        S.backgroundColor = UIColor.white
        S.layer.cornerRadius = 5
        return S
    }()
    
    fileprivate lazy var nextBtn: UIButton = {
        let tempBtn = UIButton(title: "确认", fontSize: 16, color: UIColor.white, imageName: nil, backColor: UIColor(hexString: "3289fc") ?? UIColor.black)
        tempBtn.addTarget(self, action: #selector(USEConfrimMnemonicNewVC.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        tempBtn.tag = 12
        tempBtn.layer.cornerRadius = 25
        return tempBtn
    }()
}

extension USEConfrimMnemonicNewVC {
    fileprivate func seupUI() {
        // addsubviews
        self.view.addSubview(topBackView)
        topBackView.addSubview(topWarningPointLabel)
        topBackView.addSubview(topWarningLabel)
        
        self.view.addSubview(mnemonicView)
        self.view.addSubview(mnemonicBtnView)
        self.view.addSubview(nextBtn)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // layout
        topBackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(80)
        }
        topWarningPointLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topBackView.snp.top).offset(23)
            make.left.equalTo(topBackView).offset(15)
        }
        topWarningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topBackView.snp.top).offset(26)
            make.left.equalTo(topWarningPointLabel).offset(10)
            make.right.equalTo(topBackView).offset(-10)
        }
        mnemonicView.snp.makeConstraints { (make) in
            make.top.equalTo(topBackView.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.height.equalTo(200)
        }
        mnemonicBtnView.snp.makeConstraints { (make) in
            make.top.equalTo(mnemonicView.snp.bottom).offset(10)
            make.left.right.equalTo(mnemonicView)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-20)
        }
    }
}

struct Random {
    /**
     * 如区间表示 ==> [1, end]
     */
    static func number(end: Int) -> [Int] {
        var startArr = Array(1...end)
        var resultArr = Array(repeating: 0, count: end)
        for i in 0..<startArr.count {
            let currentCount = UInt32(startArr.count - i)
            let index = Int(arc4random_uniform(currentCount))
            resultArr[i] = startArr[index]
            startArr[index] = startArr[Int(currentCount) - 1]
        }
        return resultArr
    }
    /**
     *  如半闭区间表示 ==> (start, end]
     */
    static func numberPro(start: Int, end: Int) -> [Int] {
        let scope = end - start
        var startArr = Array(1...scope)
        var resultArr = Array(repeating: 0, count: scope)
        for i in 0..<startArr.count {
            let currentCount = UInt32(startArr.count - i)
            let index = Int(arc4random_uniform(currentCount))
            resultArr[i] = startArr[index]
            startArr[index] = startArr[Int(currentCount) - 1]
        }
        return resultArr.map { $0 + start }
    }
}
