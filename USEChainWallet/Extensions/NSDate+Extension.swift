//
//  NSDate+Extension.swift
//  Dazui
//
//  Created by Jacob on 2017/3/27.
//  Copyright © 2017年 you. All rights reserved.
//

import UIKit

extension NSDate {
    /// 将字符串转换成日期
    class func strToDate(string: String) -> NSDate? {
        // 1. 转换成日期
        let df = DateFormatter()
        
        df.locale = Locale(identifier: "en")
        df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        return df.date(from: string) as NSDate?
    }
    //取得当前时间的年字符串
    class func getDateYear(date: NSDate) -> String? {
        let df = DateFormatter()
        
        df.locale = Locale(identifier: "en")
        df.dateFormat = "yyyy"
        return df.string(from: date as Date)
    }
    //取得当前时间的月份字符串
    class func getDateMonth(date: NSDate) -> String? {
        let df = DateFormatter()
        
        df.locale = Locale(identifier: "en")
        df.dateFormat = "MMM"
        return df.string(from: date as Date)
    }
    //去的当前时间的星期
    class func getDateWeek(date: NSDate) -> String? {
        let df = DateFormatter()
        
        df.locale = Locale(identifier: "en")
        df.dateFormat = "EEE"
        return df.string(from: date as Date)
    }
    //取得当前时间的天字符串
    class func getDateDay(date: NSDate) -> String? {
        let df = DateFormatter()
        
        df.locale = Locale(identifier: "en")
        df.dateFormat = "dd"
        return df.string(from: date as Date)
    }
    //获取当其时间 08:10
    class func getHourWithMinute(date: NSDate) -> String? {
        let df = DateFormatter()
        
        df.locale = Locale(identifier: "en")
        df.dateFormat = "HH:mm"
        return df.string(from: date as Date)
    }
    
    class func enMonthToNumMonth(enMonth: String!) -> String {
        switch enMonth {
        case "Jan":
            return "01"
        case "Feb":
            return "02"
        case "Mar":
            return "03"
        case "Apr":
            return "04"
        case "May":
            return "05"
        case "Jun":
            return "06"
        case "Jul":
            return "07"
        case "Aug":
            return "08"
        case "Sep":
            return "09"
        case "Oct":
            return "10"
        case "Nov":
            return "11"
        case "Dec":
            return "12"
        default:
            return "13"
        }
    }
    class func enWeekToZhWeek(enWeek: String!) -> String {
        switch enWeek {
        case "Mon":
            return "周一"
        case "Tue":
            return "周二"
        case "Wed":
            return "周三"
        case "Thur":
            return "周四"
        case "Fri":
            return "周五"
        case "Sat":
            return "周六"
        case "Sun":
            return "周日"
        default:
            return "周八"
        }
    }

        class func icoForumDate(string: String) -> NSDate? {
            // 1. 转换成日期
            let df = DateFormatter()
            
            df.locale = NSLocale(localeIdentifier: "en") as Locale!
            df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
            
            return df.date(from: string) as NSDate? ?? NSDate()
        }
        
        /**
         返回当前日期的描述信息
         
         刚刚(一分钟内)
         X分钟前(一小时内)
         X小时前(当天)
         
         昨天 HH:mm(昨天)
         MM-dd HH:mm(一年内)
         yyyy-MM-dd HH:mm(更早期)
         */
        var dateDescription: String {
            
            // 取出当前日历 - 提供了大量的日历相关的操作函数
            let calendar = NSCalendar.current
            
            // 处理今天的日期
            if calendar.isDateInToday(self as Date) {
                
                let delta = Int(NSDate().timeIntervalSince(self as Date))
                
                if delta < 60 {
                    return "刚刚"
                }
                if delta < 3600 {
                    return "\(delta / 60) 分钟前"
                }
                
                return "\(delta / 3600) 小时前"
            }
            
            // 非今天的日期
            var fmt = " HH:mm"
            if calendar.isDateInYesterday(self as Date) {
                fmt = "昨天" + fmt
            } else {
                fmt = "MM-dd" + fmt
                // 直接获取`年`的数值
                // 比较两个日期之间是否有一个完整的年度差值
//                let comps = calendar.components(.Year, fromDate: self, toDate: NSDate(), options: [])
 //               let comps = calendar.dateComponents(.year, from: self, to: NSDate())
                let releaseYear = calendar.component(.year, from: self as Date)
                let currentYear = calendar.component(.year, from: NSDate() as Date)
                let comps = releaseYear - currentYear
                if comps > 0 {
                    fmt = "yyyy-" + fmt
                }
            }
            
            // 根据格式字符串生成描述字符串
            let df = DateFormatter()
            
            df.dateFormat = fmt
            df.locale = NSLocale(localeIdentifier: "en") as Locale!
            
            return df.string(from: self as Date)
        }
    //时间戳转换标准时间
    class func timeStampToStandardTime(date: Date, format: String) -> String? {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.system
        formatter.dateFormat = format
//        formatter.dateStyle = .medium
//        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    
}
