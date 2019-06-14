//
//  USEDiscoverViewController.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/3/1.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEDiscoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
        showAlterView("敬请期待 ……", mySelf: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showAlterView("敬请期待 ……", mySelf: self)
    }
}
