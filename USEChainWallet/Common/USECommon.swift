//
//  USECommon.swift
//  USEChainWallet
//
//  Created by Jacob on 2019/4/29.
//  Copyright © 2019 Jacob. All rights reserved.
//

import Foundation


// USERecoverWalletVC
enum USERecoverWalletVCBtnTag: Int {
    case recoverConfirmed = 1
    case removeForever
}

// USEWalletImportBaseVC
let USEImportInputCellID = "USEImportInputCellID"
let USEImportPasscodeCellID = "USEImportPasscodeCellID"
let USEImportRepeatPasscodeCellID = "USEImportRepeatPasscodeCellID"
let USEImportPasscodeAttentionCellID = "USEImportPasscodeAttentionCellID"


//USEKYCAuthenticationVC
enum USEKYCAuthenticationVCBtnTag: Int {
    case pushNationPicker = 1
    case selectLeftCardType
    case selectRightCardType
    case nationPickerConfimClicked
    case nationPickerCancelClicked
    case selectMale
    case selectFemale
    case pushBirthPicker
    case addFrontIDCard
    case addBackIDCard
    case addHoldIDCard
    case nextStep
}
let kKycCardType: String = "kKycCardType"
let kPassport: String = "passport"
let kIDCard: String = "IDCard"


// USEWalletViewController
enum USEWalletVCBtnTag: Int {
    case qrcodeRefund = 1
    case walletAdministrator
    case addressCopy
    case auditing
    case creditLevel
}

// communityPulickKey
let kCommunityPublicKeyStr = ((UserDefaults.standard.value(forKey: kCommunityPulickKey) as! String) != "") ? (UserDefaults.standard.value(forKey: kCommunityPulickKey) as! String)  : "0x04fe9be04bc68aa4bdd4bfe0f5fa000d22c2f2a6dd16a0ef0dd3eabc99f8ae07363b42758e0c0dd30690b99e261a539db97549c6e2a0a136208c62ce007282b5b3"
let kPrimeStr = "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141"
let kF1ContractAddress = "0xfffffffffffffffffffffffffffffffff0000001"
let kCommunityPulickKey = "communityPulickKey"
let kEvalueateAddress = "UmKcwVZszSyTRucygwyzTenHRon64BWK48k"
let kRecoverWalletsKey = "USErecoverWalletsKey"
let kUserPrivateKeyWalletsKey = "USEUserPrivateKeyWallets"
let kUserMnemonicKeyWalletsKey = "USEUserWallets"
let kCurrentTXDetail = "currentTxDetailDict"


//------------------UserDefaluts------------------


// $Constant String$
let kUSECurrentAccountInfo = "USECurrentAccountInfo"
let kUmPublickKeyHalf = "UmPublickKeyBy"

// $Constant Function$

func kHasThisAddress(address: String) -> Bool {
    if UserDefaults.standard.value(forKey: "USEWalletsAddressStore") != nil {
        var walletsArray = UserDefaults.standard.value(forKey: "USEWalletsAddressStore") as! Array<String>
        for i in walletsArray {
            if address == i {
                return true
            }
        }
        walletsArray.append(address)
        UserDefaults.standard .setValue(walletsArray, forKey: "USEWalletsAddressStore")
        return false
    } else {
        var walletsArray = Array<String>()
        walletsArray.append(address)
        UserDefaults.standard .setValue(walletsArray, forKey: "USEWalletsAddressStore")
        return false
    }
}

func showAlterView(_ str : String, mySelf: AnyObject){
    let hud = MBProgressHUD.showAdded(to: mySelf.view, animated: true)
    hud?.mode = .text
    hud?.detailsLabelText = str
    hud?.detailsLabelFont = UIFont.systemFont(ofSize: 16)
    hud?.margin = 10.0
    hud?.yOffset = -30
    hud?.removeFromSuperViewOnHide = true
    hud?.isUserInteractionEnabled = false
    hud?.hide(true, afterDelay: 1.5)
}


func kGetCurrentAccountUMAdderss() -> String {
    let tempAddress = (UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as! Array<String>).last
    let UMAddressPubKey = kUmPublickKeyHalf + (tempAddress?.lowercased())!
    let umAddress = UseChainNetTools.getUMAddressWith(publicKey: UserDefaults.standard.value(forKey: UMAddressPubKey) as! NSString)
    return umAddress
}

func kGetCurrentAccount() -> Account {
    let walletInfo = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) as? Array<String>
    let walletStore = walletInfo![1]
    let account: Account?
    if Account.isValidMnemonicPhrase(walletStore) {
        //mnemonic
        account = UseEthersManager(mnemonicPhrase: walletStore, slot: 0)
    } else {
        //privateKey
        account = UseEthersManager(privateKey: walletStore.hexToBytes)
    }
    return account!
}

func kGetCurrentAccountInfo() -> Array<String> {

        guard let walltInfoArray = UserDefaults.standard.value(forKey: kUSECurrentAccountInfo) else {
            return []
        }
        return walltInfoArray as! Array<String>

}


func kGetCurrentAccoountWalletName() -> String {
    
    guard let currentWalletName = kGetCurrentAccountInfo().first else {
        return ""
    }
    return currentWalletName
    
}

func kGetCurrentAccountWalletInfo() -> String {
    
    let currentWalletInfo = kGetCurrentAccountInfo()[1]
    return currentWalletInfo
    
}

func kGetCurrentAccountClassicAddress() -> String {
    
    guard let currentWalletClassicAddress = kGetCurrentAccountInfo().last else {
        return ""
    }
    return currentWalletClassicAddress
    
}

//------------------internationalization------------------

// $Constant String$
let languageKey = "DZLanguageKey"

// $Constant Function$
func DZLocalizedString(_ key: String, comment: String) -> String {
    let languageStr = UserDefaults.standard.value(forKey: languageKey) as! String
    let path = Bundle.main.path(forResource: languageStr, ofType: "lproj")
    return (Bundle(path: path!)?.localizedString(forKey: key, value: nil, table: "Localizable"))!
}

func isSimplifiedChinese() -> Bool {
    let languageStr = UserDefaults.standard.value(forKey: languageKey) as! String
    if languageStr == "zh-Hans" {
        return true
    } else {
        return false
    }
}

func isTraditionalChinese() -> Bool {
    let languageStr = UserDefaults.standard.value(forKey: languageKey) as! String
    if languageStr == "zh-Hant" {
        return true
    } else {
        return false
    }
}

func isEnglish() -> Bool {
    let languageStr = UserDefaults.standard.value(forKey: languageKey) as! String
    if languageStr == "en" {
        return true
    } else {
        return false
    }
}

func isJapanese() -> Bool {
    let languageStr = UserDefaults.standard.value(forKey: languageKey) as! String
    if languageStr == "ja" {
        return true
    } else {
        return false
    }
}
