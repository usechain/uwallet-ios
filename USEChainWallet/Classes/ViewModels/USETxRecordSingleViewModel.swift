//
//  DZMuhonAssetsRecordSingleViewModel.swift
//  Dazui
//
//  Created by Jacob on 2018/1/14.
//  Copyright © 2018年 you. All rights reserved.
//

import Foundation
import UIKit

class USETxRecordSingleViewModel: CustomStringConvertible {
    var assetsRecodModel: USETxRecordModel
    
    init(assetsModel: USETxRecordModel) {
        self.assetsRecodModel = assetsModel
    }
    
    var description: String {
        return assetsRecodModel.description
    }
}
