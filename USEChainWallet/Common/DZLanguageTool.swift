//
//  DZLanguageTool.swift
//  Dazui
//
//  Created by 顾雪飞 on 2018/7/10.
//  Copyright © 2018年 you. All rights reserved.
//

import UIKit

class DZLanguageTool: NSObject {
    @objc static let shareInstance: DZLanguageTool = DZLanguageTool()
    @objc func checkAndSetLanguage() {
        var currencytLanguage = UserDefaults.standard.string(forKey: languageKey)
        // 不加条件则跟随系统语言
        if currencytLanguage == nil {
            let language = NSLocale.preferredLanguages[0]
            if language.hasPrefix("zh-Hans") {
                currencytLanguage = "zh-Hans"
            } else if language.hasPrefix("zh-Hant") {
                currencytLanguage = "zh-Hant"
            } else if language.hasPrefix("en") {
                currencytLanguage = "en"
            } else if language.hasPrefix("ja") {
                currencytLanguage = "ja"
            } else { // 其他语言
                currencytLanguage = "en"
            }
            UserDefaults.standard.setValue(currencytLanguage, forKey: languageKey)
        }
    }
}
