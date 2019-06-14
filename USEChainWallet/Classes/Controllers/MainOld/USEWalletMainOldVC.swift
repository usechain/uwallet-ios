//
//  USEWalletMainOldVC.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/1.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit


class USEWalletMainOldVC: UITabBarController {

    override func loadView() {
        super.loadView()
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    fileprivate lazy var walletVC: USEWalletViewController = USEWalletViewController()
    fileprivate lazy var discoverVC: USEDiscoverViewController = USEDiscoverViewController()
    fileprivate lazy var mineVC: USEMineViewController = USEMineViewController()

}
extension USEWalletMainOldVC {
    fileprivate func setupUI() {
        walletVC.tabBarItem.title = "钱包"
        walletVC.tabBarItem.image = UIImage.init(named: "qianbao_2")?.withRenderingMode(.alwaysOriginal)
        walletVC.tabBarItem.selectedImage = UIImage.init(named: "qianbao_1")?.withRenderingMode(.alwaysOriginal)
        discoverVC.tabBarItem.title = "发现"
        discoverVC.tabBarItem.imageInsets  = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0)
        discoverVC.tabBarItem.image = UIImage.init(named: "faxian_2")?.withRenderingMode(.alwaysOriginal)
         discoverVC.tabBarItem.selectedImage = UIImage.init(named: "faxian_1")?.withRenderingMode(.alwaysOriginal)
        mineVC.tabBarItem.title = "我的"
        mineVC.tabBarItem.image = UIImage.init(named: "me_2")?.withRenderingMode(.alwaysOriginal)
        mineVC.tabBarItem.selectedImage = UIImage.init(named: "me_1")?.withRenderingMode(.alwaysOriginal)
        
        self.addChild(walletVC)
        self.addChild(discoverVC)
        self.addChild(mineVC)
    }
    
}

extension USEWalletMainOldVC: UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer != self.navigationController?.interactivePopGestureRecognizer
    }
    
}
