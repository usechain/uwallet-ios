//
//  DZMuhonAssetsRecordModel.swift
//  Dazui
//
//  Created by Jacob on 2018/1/12.
//  Copyright © 2018年 you. All rights reserved.
//

import UIKit


class USETxRecordModel: NSObject {
    
    var blockHash: String?
    
    var blockNumber: NSNumber?
    
    var blockTimeStamp: NSNumber?
    
    var contractAddress: String?
    
    var gas: NSNumber?
    
    var gasPrice: NSNumber?
    
    var gasUsed: NSNumber?
    
    var input: String?
    
    var nonce: NSNumber?
    
    var txFrom: String?
    
    var txHash: String?
    
    var txTo: String?
    
    var txValue: String?
    
    init(dict: [String: Any]) {
        super.init()

        self.blockHash  = dict["blockHash"] as? String
        self.blockNumber = dict["blockNumber"] as? NSNumber
        self.blockTimeStamp = dict["blockTimeStamp"] as? NSNumber
        self.contractAddress = dict["from"] as? String
        self.gas = dict["gas"] as? NSNumber
        self.gasPrice = dict["gasPrice"] as? NSNumber
        self.gasUsed = dict["gasUsed"] as? NSNumber
        self.input = dict["input"] as? String
        self.nonce = dict["nonce"] as? NSNumber
        self.txFrom = dict["txFrom"] as? String
        self.txHash = dict["txHash"] as? String
        self.txTo = dict["txTo"] as? String
        self.txValue = dict["txValue"] as? String
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
