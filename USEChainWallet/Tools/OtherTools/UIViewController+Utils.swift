//
//  UIViewController+Utils.swift
//  Dazui
//
//  Created by wakaka on 2017/9/11.
//  Copyright © 2017年 you. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func findBestViewController(vc: UIViewController) -> UIViewController {
        
        if vc.presentedViewController != nil {
            return vc.presentedViewController!
        }else if vc.isKind(of: UISplitViewController.self) {
            let svc = vc as! UISplitViewController
            if svc.viewControllers.count > 0 {
                return svc.viewControllers.last!
            }else {
                return vc
            }
        }else if vc.isKind(of: UINavigationController.self) {
            let svc = vc as! UINavigationController
            if svc.viewControllers.count > 0 {
                return svc.topViewController!
            }else {
                return vc
            }
        }else if vc.isKind(of: UITabBarController.self) {
            let svc = vc as! UITabBarController
            if (svc.viewControllers?.count)! > 0 {
                return svc.selectedViewController!
            }else {
                return vc
            }
        }else {
            return vc
        }
    }
    
    static func currentViewController() -> UIViewController {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            return UIViewController.findBestViewController(vc: vc)
        }else {
            return nil as UIViewController!
        }
    }
}
