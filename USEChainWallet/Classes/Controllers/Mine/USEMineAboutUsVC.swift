//
//  USEMineAboutUsVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/30.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEMineAboutUsVC: USEWalletBaseVC {
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "关于我们"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        backScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 1000)
    }
    fileprivate lazy var backScrollView: UIScrollView = {
        let temp = UIScrollView()
        temp.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 1000)
        temp.backgroundColor = UIColor.white
        temp.isScrollEnabled = true
        temp.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return temp
    }()
    fileprivate lazy var topImageView: UIImageView = UIImageView(image: UIImage.init(named: "USE"))
    fileprivate lazy var topTitleLabel: UILabel = UILabel(title: "Usechain Wallet", fontSize: 16, color: UIColor(red: 18/255, green: 116/255, blue: 214/255, alpha: 1.0), redundance: 0)
    fileprivate lazy var topLabel: UILabel = UILabel(title: "V 1.0.0", fontSize: 18, color: UIColor(hexString: "333333") ?? UIColor.gray, redundance: 0)    
    fileprivate lazy var useTitleLabel: UILabel = UILabel(title: "Usechain是什么?", fontSize: 24, color: UIColor.black, redundance: 0)
    fileprivate lazy var bottomTitleLabel: UILabel = {
        let temp = UILabel(title: "      Usechain是全球第一个隐身镜像区块链生态系统，在Usechain的链上镜像世界中，隐身镜像协议Mirror Identity Protocol(MIP)把链下真实世界的身份与链上镜像世界的账户相关联，在身份的基础上全面复制华尔街的金融业务，在镜像世界中打造一个去中介化、低交易成本、大规模、高效率的链上华尔街。\n  Usechain首创Randomized Proof of Work(RPOW)共识算法，将突破区块链发展瓶颈，实现安全、效率和规模的平衡。通过在区块链上的真实身份映射，在保护用户隐私的前提之下满足金融系统中最重要的KYC(了解客户)及AML(反洗钱)原则,降低使用技术门槛，促进去中心化应用的真正落地，在链上的镜像世界中推进全球普惠金融，打造链上华尔街。", fontSize: 18, color: UIColor(hexString: "333333") ?? UIColor.gray, redundance: 40)
            let attri = NSMutableAttributedString(string: temp.text!)
            let para = NSMutableParagraphStyle.init()
            para.alignment = .justified
        
        attri.addAttributes([ .paragraphStyle: para , .underlineStyle :  NSNumber.init(value: Int8(NSUnderlineStyle.init().rawValue))
            ], range: NSMakeRange(0, attri.length))
            temp.attributedText = attri
        return temp
    }()
    fileprivate lazy var useGroupTitleLabel: UILabel = UILabel(title: "Usechain团队实力如何?", fontSize: 24, color: UIColor.black, redundance: 0)
    fileprivate lazy var useGroupLabel: UILabel = {
        let temp = UILabel(title: "      Usechain由全球金融专家、长江商学院金融学教授、中国大陆第一个金融MBA创始人曹辉宁教授任CEO；由国家“千人计划”专家，拥有近三十年国内外量化对冲经验，曾任花旗集团/摩根士丹利资产管理部董事总经理张峰博士出任资深金融专家l；由长江商学院市场营销教授、杰出院长讲席教授、美洲市场副院长、美国卡内基梅隆大学营销学讲席教授孙宝红博士任首席战略官。\n        已拥有近40人扎实的团队，在纽约、深圳、北京等地设有分支机构。", fontSize: 18, color: UIColor(hexString: "333333") ?? UIColor.gray, redundance: 40)
        let attri = NSMutableAttributedString(string: temp.text!)
        let para = NSMutableParagraphStyle.init()
        para.alignment = .justified
        attri.addAttributes([ .paragraphStyle: para , .underlineStyle :  NSNumber.init(value: Int8(NSUnderlineStyle.init().rawValue))
            ], range: NSMakeRange(0, attri.length))
        temp.attributedText = attri
        return temp
    }()
    fileprivate lazy var bottomLabel: UILabel = UILabel(title: "Copyright 2018-2019 Usechain Foundation All right Reserved", fontSize: 14, color: UIColor(hexString: "999999") ?? UIColor.gray, redundance: 150, align: true)
    
}

extension USEMineAboutUsVC {
    
    fileprivate func setupUI() {
        self.view.addSubview(backScrollView)
        backScrollView.addSubview(topImageView)
        backScrollView.addSubview(topTitleLabel)
        backScrollView.addSubview(topLabel)
        backScrollView.addSubview(bottomTitleLabel)
        backScrollView.addSubview(bottomLabel)
        backScrollView.addSubview(useTitleLabel)
        backScrollView.addSubview(useGroupTitleLabel)
        backScrollView.addSubview(useGroupLabel)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        backScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        topImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(backScrollView)
            make.top.equalTo(backScrollView).offset(30)
        }
        topTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(backScrollView)
            make.top.equalTo(topImageView.snp.bottom).offset(20)
        }
        topLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(backScrollView)
            make.top.equalTo(topTitleLabel.snp.bottom).offset(30)
        }
        useTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(30)
            make.left.equalTo(self.backScrollView).offset(15)
        }
        bottomTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(backScrollView)
            make.top.equalTo(useTitleLabel.snp.bottom).offset(5)
        }
        useGroupTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomTitleLabel.snp.bottom).offset(30)
            make.left.equalTo(self.backScrollView).offset(15)
        }
        useGroupLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(backScrollView)
            make.top.equalTo(useGroupTitleLabel.snp.bottom).offset(5)
        }
        bottomLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(backScrollView)
            make.top.equalTo(useGroupLabel.snp.bottom).offset(50)
        }
    }
    
}
