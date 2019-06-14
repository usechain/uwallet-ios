//
//  basePassWordTF.swift
//  Dazui
//
//  Created by Mr_朱 on 2017/8/15.
//  Copyright © 2017年 you. All rights reserved.
//

import UIKit

//禁止长按控件，false：禁止
class basePassWordTF: UITextField {
    var menu : UIMenuController?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        menu = UIMenuController.shared
        if menu != nil {
            menu?.isMenuVisible = false
        }
        return false
    }
}
