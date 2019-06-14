//
//  regularObject.swift
//  Dazui
//  正则表达式
//  Created by Mr_朱 on 2017/7/5.
//  Copyright © 2017年 you. All rights reserved.
//

import UIKit

enum ValidatedType {
    case Email  //邮箱
    case PhoneNumber    //手机号
    case LoginPassWord  //登录密码8-16位字母 数字和符号至少两种
    case PayPassWord  //支付密码6位数字字符
    case Number //纯数字
    case Double // 4位小数
}

class ValidatedPutIn: NSObject {
    static func ValidateText(validatedType type: ValidatedType, validateString: String) -> Bool {
        do {
            let pattern: String
            if type == ValidatedType.Email {
                pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            }
            else if type == ValidatedType.PhoneNumber{
                pattern = "^((13[0-9])|(14[5,7])|(15[^4,\\D])|(17[6-8])|(18[0,0-9]))\\d{8}|(170[5,9])\\d{7}$"
            }
            else if type == ValidatedType.LoginPassWord{
                pattern = "^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{8,16}$"
//                pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)(?!([^(0-9a-zA-Z)]|[\\(\\)])+$)([^(0-9a-zA-Z)]|[\\(\\)]|[a-zA-Z]|[0-9]){8,16}$"
            }
            else if type == ValidatedType.PayPassWord{
                pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6}$"
            }
            else if type == ValidatedType.Number{
                pattern = "^[0-9]*$"
            }
            else if type == ValidatedType.Double{
                pattern = "^([1-9]\\d{0,15}|0)(\\.\\d{1,4}|\\.)?$"
            }
            else{
                pattern = ""
            }
            
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
    
    //邮箱
    static func EmailIsValidated(_ vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.Email, validateString: vStr)
    }
    
    //手机号
    static func PhoneNumberIsValidated(_ vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.PhoneNumber, validateString: vStr)
    }
    
    //登录密码
    static func LoginPassWordIsValidated(_ vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.LoginPassWord, validateString: vStr)
    }
    
    //支付密码
    static func PayPassWordIsValidated(_ vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.PayPassWord, validateString: vStr)
    }
    
    //是否是纯数字
    static func NumberIsValidated(_ vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.Number, validateString: vStr)
    }
    
    //是否是4位小数
    static func doubleIsValidated(_ vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.Double, validateString: vStr)
    }
}
