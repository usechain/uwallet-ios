//
//  DZMuhonAssetsRecordViewModel.swift
//  Dazui
//
//  Created by Jacob on 2018/1/12.
//  Copyright © 2018年 you. All rights reserved.
//

import UIKit
import Foundation

class USETxRecordViewModel {
    
    var useTxRecordPullRequestList = [USETxRecordSingleViewModel]()
    var dzMuhonDetailDict: NSDictionary?
    var turnInPages = 0
    var messages: String?
    
    func loadTurnInDatas(finished: @escaping (_ isSuccessed: Bool)->()) -> () {
        turnInPages = 0
        let umAddress = kGetCurrentAccountUMAdderss()
        let combineUrlStr = String(format: "transfer/%@/page=%@&items=20", umAddress, "\(turnInPages)")
        UseWalletNetworkTools.sharedUSEBrowser()?.request("GET", urlString: combineUrlStr, parameters: nil, finished: { (result, error) in
            if result == nil || (result as! [String: Any]).isEmpty || ((result as! [String: Any])["Error"] as! String) != "" {
                finished(false)
                return
            }
            let resultData = ((result as! [String: Any])["Data"]) as! [String: Any]
            let listArray = resultData["list"] as! NSArray
            var tempArrayM = [USETxRecordSingleViewModel]()
            for dict in listArray {
                tempArrayM.append(USETxRecordSingleViewModel(assetsModel: USETxRecordModel(dict: dict as! [String : Any])))
            }
            self.useTxRecordPullRequestList = tempArrayM
            finished(true)
        })
    }
    
    func loadPreTurnInDatas(finished: @escaping (_ isSuccessed: Bool)->()) -> () {
        turnInPages += 1
        let umAddress = kGetCurrentAccountUMAdderss()
        let combineUrlStr = String(format: "transfer/%@/page=%@&items=20", umAddress, "\(turnInPages)")
        UseWalletNetworkTools.sharedUSEBrowser()?.request("GET", urlString: combineUrlStr, parameters: nil, finished: { (result, error) in
            if result == nil || (result as! [String: Any]).isEmpty || ((result as! [String: Any])["Error"] as! String) != "" {
                finished(false)
                return
            }
            let resultData = ((result as! [String: Any])["Data"]) as! [String: Any]
            let count = ((resultData )["count"]) as! Int
            let listArray = resultData["list"] as! NSArray
            if count == 0 {
                self.turnInPages -= 1
                finished(false)
                return
            }
            var tempArrayM = [USETxRecordSingleViewModel]()
            for dict in listArray {
                tempArrayM.append(USETxRecordSingleViewModel(assetsModel: USETxRecordModel(dict: dict as! [String : Any])))
            }
            self.useTxRecordPullRequestList += tempArrayM
            finished(true)
        })
    }
}
