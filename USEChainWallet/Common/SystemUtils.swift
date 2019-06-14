//
//  SystemUtils.swift
//  Dazui
//
//  Created by wakaka on 2017/10/27.
//  Copyright © 2017年 you. All rights reserved.
//

import UIKit

class SystemUtils: NSObject {
    
//    获取当前语言环境
    static func getCurrentLanguage() -> String {
        let preferredLang = Bundle.main.preferredLocalizations.first! as String
        if preferredLang.hasPrefix("en") {
            return "3"
        }else if preferredLang.hasPrefix("zh-Hans"){
            return "1"
        }else if preferredLang.hasPrefix("zh-Hant") {
            return "2"
        }
        return "1"
    }
}
