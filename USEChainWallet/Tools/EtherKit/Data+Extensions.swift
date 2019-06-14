//
//  Data+Extensions.swift
//  EtherKit
//
//  Created by Cole Potrocky on 4/26/18.
//


extension Data {


  public var paddedHexString: String {
    return reduce("0x") { "\($0)\(String(format: "%02x", $1))" }
  }
    
//    public func sha3(_ variant: SHA3.Variant) -> Data {
//        return Data(bytes: Digest.sha3(bytes, variant: variant))
//    }
    /// - Returns: kaccak256 hash of data
    static func fromHex(_ hex: String) -> Data? {
        let string = hex.lowercased().withoutHex
        let data = string.hex
        if data.count == 0 {
            if string == "" {
                return Data()
            } else {
                return nil
            }
        }
        return data
    }

}
