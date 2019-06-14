//
//  USEAddressTools.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/6/4.
//  Copyright © 2019 Jacob. All rights reserved.
//

import UIKit

class USEAddressTools: NSObject {
    
    @objc class func isValidUSEAddress(address: String) -> Bool {
        
        if address == "" {
            return false
        }

        if !UseChainNetTools.checkUMAddress(address: address) {
            return false
        }
        
        let normalAddress = UseChainNetTools.recoverToNormalAddress(umAddress: address)
        
        do {
            try  AddressValidator().validate(address: normalAddress )
        } catch  USEChainWallet.AddressValidator.ValidationError.invalidChecksum {
            return false
        } catch  USEChainWallet.AddressValidator.ValidationError.invalidAddressLength {
            return false
        } catch  USEChainWallet.AddressValidator.ValidationError.invalidSymbols {
            return false
        } catch USEChainWallet.AddressValidator.ValidationError.wrongAddressPrefix {
            return false
        } catch {
            return false
        }
        
        
        return true
    }
    
}
