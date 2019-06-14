//
//  USEMainNetWebviewVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/29.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEMainNetWebviewVC: USEWalletBaseVC {

    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate lazy var mainNetWebView: UIWebView = {
        let temp = UIWebView()
        let urlStr = "http://mainnet.usechain.cn/#/"
        let url = NSURL(string: urlStr)
        let urlRequest = NSURLRequest(url: url! as URL)
        temp.loadRequest(urlRequest as URLRequest)
        return temp
    }()
    
}

extension USEMainNetWebviewVC {
    
    fileprivate func setupUI() {
        self.view.addSubview(mainNetWebView)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        mainNetWebView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
}
