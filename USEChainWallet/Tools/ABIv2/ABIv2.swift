//
//  ABIv2.swift
//  web3swift
//
//  Created by Alexander Vlasov on 02.04.2018.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//

import Foundation
import BigInt
import HSCryptoKit

/// Element type protocol
protocol ABIv2ElementPropertiesProtocol {
    /// Returns true if array is has fixed length
    var isStatic: Bool { get }
    /// Returns true if type is array
    var isArray: Bool { get }
    /// Returns true if type is tuple
    var isTuple: Bool { get }
    /// Returns array size if type
    var arraySize: ABIv2.Element.ArraySize { get }
    /// Returns subtype of array
    var subtype: ABIv2.Element.ParameterType? { get }
    /// Returns memory usage of type
    var memoryUsage: UInt64 { get }
    /// Returns default empty value for type
    var emptyValue: Any { get }
}

protocol ABIv2Encoding {
    var abiRepresentation: String { get }
}

protocol ABIv2Validation {
    var isValid: Bool { get }
}

/// Parses smart contract json abi to work with smart contract's functions
public struct ABIv2 {}

extension ABIv2 {
    /// Function input parameter
    public struct Input: Decodable {
        var name: String?
        var type: String
        var indexed: Bool?
        var components: [Input]?
    }

    /// Function output parameter
    public struct Output: Decodable {
        var name: String?
        var type: String
        var components: [Output]?
    }

    /// Function
    public struct Record: Decodable {
        var name: String?
        var type: String?
        var payable: Bool?
        var constant: Bool?
        var stateMutability: String?
        var inputs: [ABIv2.Input]?
        var outputs: [ABIv2.Output]?
        var anonymous: Bool?
    }

    /// Abi Element
    public enum Element {
        /// Array size
        public enum ArraySize { // bytes for convenience
            /// Fixed size array or data
            case staticSize(UInt64)
            /// Dynamic size for dynamic arrays or data
            case dynamicSize
            /// Any other type
            case notArray
        }

        /// Function type
        case function(Function)
        /// Constructor
        case constructor(Constructor)
        /// Fallback
        case fallback(Fallback)
        /// Event
        case event(Event)

        /// Input or output type
        public struct InOut {
            let name: String
            let type: ParameterType
        }

        /// Function type
        public struct Function {
            let name: String?
            let inputs: [InOut]
            let outputs: [InOut]
            let constant: Bool
            let payable: Bool
        }

        /// Constructor type
        public struct Constructor {
            let inputs: [InOut]
            let constant: Bool
            let payable: Bool
        }

        /// Fallback type
        public struct Fallback {
            let constant: Bool
            let payable: Bool
        }

        /// Event type
        public struct Event {
            let name: String
            let inputs: [Input]
            let anonymous: Bool

            struct Input {
                let name: String
                let type: ParameterType
                let indexed: Bool
            }
        }
    }
}

extension ABIv2.Element {
    func encodeParameters(_ parameters: [AnyObject]) -> Data? {
        switch self {
        case let .constructor(constructor):
            guard parameters.count == constructor.inputs.count else { return nil }
            guard let data = ABIv2Encoder.encode(types: constructor.inputs, values: parameters) else { return nil }
            return data
        case .event:
            return nil
        case .fallback:
            return nil
        case let .function(function):
            guard parameters.count == function.inputs.count else { return nil }
            let signature = function.methodEncoding
            guard let data = ABIv2Encoder.encode(types: function.inputs, values: parameters) else { return nil }
            return signature + data
        }
    }
}

extension ABIv2.Element {
    func decodeReturnData(_ data: Data) -> [String: Any]? {
        switch self {
        case .constructor:
            return nil
        case .event:
            return nil
        case .fallback:
            return nil
        case let .function(function):
            if data.count == 0 && function.outputs.count == 1 {
                let name = "0"
                let value = function.outputs[0].type.emptyValue
                var returnArray = [String: Any]()
                returnArray[name] = value
                if function.outputs[0].name != "" {
                    returnArray[function.outputs[0].name] = value
                }
                return returnArray
            }

            guard function.outputs.count * 32 <= data.count else { return nil }
            var returnArray = [String: Any]()
            var i = 0
            guard let values = ABIv2Decoder.decode(types: function.outputs, data: data) else { return nil }
            for output in function.outputs {
                let name = "\(i)"
                returnArray[name] = values[i]
                if output.name != "" {
                    returnArray[output.name] = values[i]
                }
                i = i + 1
            }
            return returnArray
        }
    }

    func decodeInputData(_ rawData: Data) -> [String: Any]? {
        var data = rawData
        var sig: Data?
        switch rawData.count % 32 {
        case 0:
            break
        case 4:
            sig = rawData[0 ..< 4]
            data = Data(rawData[4 ..< rawData.count])
        default:
            return nil
        }
        switch self {
        case let .constructor(function):
            if data.count == 0 && function.inputs.count == 1 {
                let name = "0"
                let value = function.inputs[0].type.emptyValue
                var returnArray = [String: Any]()
                returnArray[name] = value
                if function.inputs[0].name != "" {
                    returnArray[function.inputs[0].name] = value
                }
                return returnArray
            }

            guard function.inputs.count * 32 <= data.count else { return nil }
            var returnArray = [String: Any]()
            var i = 0
            guard let values = ABIv2Decoder.decode(types: function.inputs, data: data) else { return nil }
            for input in function.inputs {
                let name = "\(i)"
                returnArray[name] = values[i]
                if input.name != "" {
                    returnArray[input.name] = values[i]
                }
                i = i + 1
            }
            return returnArray
        case .event:
            return nil
        case .fallback:
            return nil
        case let .function(function):
            if sig != nil && sig != function.methodEncoding {
                return nil
            }
            if data.count == 0 && function.inputs.count == 1 {
                let name = "0"
                let value = function.inputs[0].type.emptyValue
                var returnArray = [String: Any]()
                returnArray[name] = value
                if function.inputs[0].name != "" {
                    returnArray[function.inputs[0].name] = value
                }
                return returnArray
            }

            guard function.inputs.count * 32 <= data.count else { return nil }
            var returnArray = [String: Any]()
            var i = 0
            guard let values = ABIv2Decoder.decode(types: function.inputs, data: data) else { return nil }
            for input in function.inputs {
                let name = "\(i)"
                returnArray[name] = values[i]
                if input.name != "" {
                    returnArray[input.name] = values[i]
                }
                i = i + 1
            }
            return returnArray
        }
    }
}

extension ABIv2.Element.Event {
//    func decodeReturnedLogs(_ eventLog: EventLog) -> [String: Any]? {
//        guard let eventContent = ABIv2Decoder.decodeLog(event: self, eventLog: eventLog) else { return nil }
//        return eventContent
//    }
}

extension ABIv2.Element {
    /// Specifies the type that parameters in a contract have.
    public enum ParameterType: ABIv2ElementPropertiesProtocol {
        /// uintN type
        case uint(bits: UInt64)
        /// intN type
        case int(bits: UInt64)
        /// address type
        case address
        /// function type
        case function
        /// bool type
        case bool
        /// bytesN type
        case bytes(length: UInt64)
        /// array[N] or array[] type
        indirect case array(type: ParameterType, length: UInt64)
        /// bytes type
        case dynamicBytes
        /// string type
        case string
        /// tuple type
        indirect case tuple(types: [ParameterType])

        var isStatic: Bool {
            switch self {
            case .string:
                return false
            case .dynamicBytes:
                return false
            case let .array(type: type, length: length):
                return length > 0 && type.isStatic
            case let .tuple(types: types):
                return types.allSatisfy { $0.isStatic }
            case .bytes(length: _):
                return true
            default:
                return true
            }
        }

        var isArray: Bool {
            switch self {
            case .array:
                return true
            default:
                return false
            }
        }

        var isTuple: Bool {
            switch self {
            case .tuple:
                return true
            default:
                return false
            }
        }

        var subtype: ABIv2.Element.ParameterType? {
            switch self {
            case .array(type: let type, length: _):
                return type
            default:
                return nil
            }
        }

        var memoryUsage: UInt64 {
            switch self {
            case let .array(_, length: length):
                if length == 0 {
                    return 32
                }
                if self.isStatic {
                    return 32 * length
                }
                return 32
            case let .tuple(types: types):
                if !self.isStatic {
                    return 32
                }
                var sum: UInt64 = 0
                for t in types {
                    sum = sum + t.memoryUsage
                }
                return sum
            default:
                return 32
            }
        }

        var emptyValue: Any {
            switch self {
            case .uint:
                return BigUInt(0)
            case .int:
                return BigUInt(0)
            case .address:
                return Address(string: "0x0000000000000000000000000000000000000000")
            case .function:
                return Data(repeating: 0x00, count: 24)
            case .bool:
                return false
            case let .bytes(length: length):
                return Data(repeating: 0x00, count: Int(length))
            case let .array(type: type, length: length):
                let emptyValueOfType = type.emptyValue
                return Array(repeating: emptyValueOfType, count: Int(length))
            case .dynamicBytes:
                return Data()
            case .string:
                return ""
            case .tuple(types: _):
                return [Any]()
            }
        }

        var arraySize: ABIv2.Element.ArraySize {
            switch self {
            case .array(type: _, length: let length):
                if length == 0 {
                    return ArraySize.dynamicSize
                } else {
                    return ArraySize.staticSize(length)
                }
            default:
                return ArraySize.notArray
            }
        }
    }
}

extension ABIv2.Element.ParameterType: Equatable {
    public static func == (lhs: ABIv2.Element.ParameterType, rhs: ABIv2.Element.ParameterType) -> Bool {
        switch (lhs, rhs) {
        case let (.uint(length1), .uint(length2)):
            return length1 == length2
        case let (.int(length1), .int(length2)):
            return length1 == length2
        case (.address, .address):
            return true
        case (.bool, .bool):
            return true
        case let (.bytes(length1), .bytes(length2)):
            return length1 == length2
        case (.function, .function):
            return true
        case let (.array(type1, length1), .array(type2, length2)):
            return type1 == type2 && length1 == length2
        case (.dynamicBytes, .dynamicBytes):
            return true
        case (.string, .string):
            return true
        default:
            return false
        }
    }
}

extension ABIv2.Element.Function {
    /// String representation of solidity function for hashing
    public var signature: String {
        return "\(name ?? "")(\(inputs.map { $0.type.abiRepresentation }.joined(separator: ",")))"
    }

    /// Function hash in hex
    public var methodString: String {
      //  CryptoKit.sha3(hashData).toHexString()
      //  return signature.keccak256().hex
        return CryptoKit.sha3(signature.toData()).toHexString()
    }

    /// Function hash
    public var methodEncoding: Data {
        let fullHash = CryptoKit.sha3(signature.toData())
       
       // return signature.data(using: .ascii)!.keccak256()[0..<4]
        return fullHash[0 ..< 4]
    }
}

// MARK: - Event topic

extension ABIv2.Element.Event {
    /// String representation of solidity event for hashing
    public var signature: String {
        return "\(name)(\(inputs.map { $0.type.abiRepresentation }.joined(separator: ",")))"
    }

    /// Event hash
    public var topic: Data {
         let fullHash = CryptoKit.sha3(signature.toData())
//        return signature.data(using: .ascii)!.keccak256()
        return fullHash
    }
}

extension ABIv2.Element.ParameterType: ABIv2Encoding {
    /// Solidity type representation
    public var abiRepresentation: String {
        switch self {
        case let .uint(bits):
            return "uint\(bits)"
        case let .int(bits):
            return "int\(bits)"
        case .address:
            return "address"
        case .bool:
            return "bool"
        case let .bytes(length):
            return "bytes\(length)"
        case .dynamicBytes:
            return "bytes"
        case .function:
            return "function"
        case let .array(type: type, length: length):
            if length == 0 {
                return "\(type.abiRepresentation)[]"
            }
            return "\(type.abiRepresentation)[\(length)]"
        case let .tuple(types: types):
            let typesRepresentation = types.map { $0.abiRepresentation }
            let typesJoined = typesRepresentation.joined(separator: ",")
            return "tuple(\(typesJoined))"
        case .string:
            return "string"
        }
    }
}

extension ABIv2.Element.ParameterType: ABIv2Validation {
    /// Returns true if type is valid (or false for types like uint257)
    public var isValid: Bool {
        switch self {
        case let .uint(bits), let .int(bits):
            return bits > 0 && bits <= 256 && bits % 8 == 0
        case let .bytes(length):
            return length > 0 && length <= 32
        case .array(type: let type, _):
            return type.isValid
        case let .tuple(types: types):
            for t in types {
                if !t.isValid {
                    return false
                }
            }
            return true
        default:
            return true
        }
    }
}

/// Encoding functions
public struct ABIv2Encoder {

    /// Converts value to BigUInt
    public static func convertToBigUInt(_ value: AnyObject) -> BigUInt? {
        switch value {
        case let v as BigUInt:
            return v
        case let v as BigInt:
            switch v.sign {
            case .minus:
                return nil
            case .plus:
                return v.magnitude
            }
        case let v as String:
            let base10 = BigUInt(v, radix: 10)
            if base10 != nil {
                return base10!
            }
            let base16 = BigUInt(v.stripHexPrefix(), radix: 16)
            if base16 != nil {
                return base16!
            }
            break
        case let v as UInt:
            return BigUInt(v)
        case let v as UInt8:
            return BigUInt(v)
        case let v as UInt16:
            return BigUInt(v)
        case let v as UInt32:
            return BigUInt(v)
        case let v as UInt64:
            return BigUInt(v)
        case let v as Int:
            return BigUInt(v)
        case let v as Int8:
            return BigUInt(v)
        case let v as Int16:
            return BigUInt(v)
        case let v as Int32:
            return BigUInt(v)
        case let v as Int64:
            return BigUInt(v)
        default:
            return nil
        }
        return nil
    }

    /// Converts value to BigInt
    public static func convertToBigInt(_ value: AnyObject) -> BigInt? {
        switch value {
        case let v as BigUInt:
            return BigInt(v)
        case let v as BigInt:
            return v
        case let v as String:
            let base10 = BigInt(v, radix: 10)
            if base10 != nil {
                return base10
            }
            let base16 = BigInt(v.stripHexPrefix(), radix: 16)
            if base16 != nil {
                return base16
            }
            break
        case let v as UInt:
            return BigInt(v)
        case let v as UInt8:
            return BigInt(v)
        case let v as UInt16:
            return BigInt(v)
        case let v as UInt32:
            return BigInt(v)
        case let v as UInt64:
            return BigInt(v)
        case let v as Int:
            return BigInt(v)
        case let v as Int8:
            return BigInt(v)
        case let v as Int16:
            return BigInt(v)
        case let v as Int32:
            return BigInt(v)
        case let v as Int64:
            return BigInt(v)
        default:
            return nil
        }
        return nil
    }

    /// Converts data to value to solidity data
    public static func convertToData(_ value: AnyObject) -> Data? {
        switch value {
        case let d as Data:
            return d
        case let d as String:
            if d.isHex, let hex = Data.fromHex(d) {
                return hex
            } else {
                return d.toData()
            }
        case let d as [UInt8]:
            return Data(d)
        case let d as Address:
            return d.data
        case let d as [IntegerLiteralType]:
            var bytesArray = [UInt8]()
            for el in d {
                guard el >= 0, el <= 255 else { return nil }
                bytesArray.append(UInt8(el))
            }
            return Data(bytesArray)
        default:
            return nil
        }
    }

    /// Encodes values with provided scheme to solidity data
    public static func encode(types: [ABIv2.Element.InOut], values: [AnyObject]) -> Data? {
        guard types.count == values.count else { return nil }
        let params = types.compactMap { (el) -> ABIv2.Element.ParameterType in
            return el.type
        }
        return encode(types: params, values: values)
    }

    /// Encodes values with provided scheme to solidity data
    public static func encode(types: [ABIv2.Element.ParameterType], values: [AnyObject]) -> Data? {
        guard types.count == values.count else { return nil }
        var tails = [Data]()
        var heads = [Data]()
        for i in 0 ..< types.count {
            let enc = encodeSingleType(type: types[i], value: values[i])
            guard let encoding = enc else { return nil }
            if types[i].isStatic {
                heads.append(encoding)
                tails.append(Data())
            } else {
                heads.append(Data(repeating: 0x0, count: 32))
                tails.append(encoding)
            }
        }
        var headsConcatenated = Data()
        for h in heads {
            headsConcatenated.append(h)
        }
        var tailsPointer = BigUInt(headsConcatenated.count)
        headsConcatenated = Data()
        var tailsConcatenated = Data()
        for i in 0 ..< types.count {
            let head = heads[i]
            let tail = tails[i]
            if !types[i].isStatic {
                guard let newHead = tailsPointer.abiEncode(bits: 256) else { return nil }
                headsConcatenated.append(newHead)
                tailsConcatenated.append(tail)
                tailsPointer = tailsPointer + BigUInt(tail.count)
            } else {
                headsConcatenated.append(head)
                tailsConcatenated.append(tail)
            }
        }
        return headsConcatenated + tailsConcatenated
    }

    /// Encodes single value with scheme to solidity data
    public static func encodeSingleType(type: ABIv2.Element.ParameterType, value: AnyObject) -> Data? {
        switch type {
        case .uint:
            if let biguint = convertToBigUInt(value) {
                return biguint.abiEncode(bits: 256)
            }
            if let bigint = convertToBigInt(value) {
                return bigint.abiEncode(bits: 256)
            }
        case .int:
            if let biguint = convertToBigUInt(value) {
                return biguint.abiEncode(bits: 256)
            }
            if let bigint = convertToBigInt(value) {
                return bigint.abiEncode(bits: 256)
            }
        case .address:
            if let string = value as? String {
                let address = Address(string: string)
              //  guard address.isValid else { return nil }
                let data = address.data
                return data.setLengthLeft(32)
            } else if let address = value as? Address {
              //  guard address.isValid else { break }
                let data = address.data
                return data.setLengthLeft(32)
            } else if let data = value as? Data {
                return data.setLengthLeft(32)
            }
        case .bool:
            if let bool = value as? Bool {
                if bool {
                    return BigUInt(1).abiEncode(bits: 256)
                } else {
                    return BigUInt(0).abiEncode(bits: 256)
                }
            }
        case let .bytes(length):
            guard let data = convertToData(value) else { break }
            if data.count > length { break }
            return data.setLengthRight(32)
        case .string:
            if let string = value as? String {
                var dataGuess: Data?
                if string.isHex {
                    dataGuess = Data.fromHex(string.lowercased().withoutHex)
                } else {
                    dataGuess = string.toData()
                }
                guard let data = dataGuess else { break }
                let minLength = ((data.count + 31) / 32) * 32
                guard let paddedData = data.setLengthRight(UInt64(minLength)) else { break }
                let length = BigUInt(data.count)
                guard let head = length.abiEncode(bits: 256) else { break }
                let total = head + paddedData
                return total
            }
        case .dynamicBytes:
            guard let data = convertToData(value) else { break }
            let minLength = ((data.count + 31) / 32) * 32
            guard let paddedData = data.setLengthRight(UInt64(minLength)) else { break }
            let length = BigUInt(data.count)
            guard let head = length.abiEncode(bits: 256) else { break }
            let total = head + paddedData
            return total
        case let .array(type: subType, length: length):
            switch type.arraySize {
            case .dynamicSize:
                guard length == 0 else { break }
                guard let val = value as? [AnyObject] else { break }
                guard let lengthEncoding = BigUInt(val.count).abiEncode(bits: 256) else { break }
                if subType.isStatic {
                    // work in a previous context
                    var toReturn = Data()
                    for i in 0 ..< val.count {
                        let enc = encodeSingleType(type: subType, value: val[i])
                        guard let encoding = enc else { break }
                        toReturn.append(encoding)
                    }
                    let total = lengthEncoding + toReturn
                    //                    print("Dynamic array of static types encoding :\n" + String(total.hex))
                    return total
                } else {
                    // create new context
                    var tails = [Data]()
                    var heads = [Data]()
                    for i in 0 ..< val.count {
                        let enc = encodeSingleType(type: subType, value: val[i])
                        guard let encoding = enc else { return nil }
                        heads.append(Data(repeating: 0x0, count: 32))
                        tails.append(encoding)
                    }
                    var headsConcatenated = Data()
                    for h in heads {
                        headsConcatenated.append(h)
                    }
                    var tailsPointer = BigUInt(headsConcatenated.count)
                    headsConcatenated = Data()
                    var tailsConcatenated = Data()
                    for i in 0 ..< val.count {
                        let head = heads[i]
                        let tail = tails[i]
                        if tail != Data() {
                            guard let newHead = tailsPointer.abiEncode(bits: 256) else { return nil }
                            headsConcatenated.append(newHead)
                            tailsConcatenated.append(tail)
                            tailsPointer = tailsPointer + BigUInt(tail.count)
                        } else {
                            headsConcatenated.append(head)
                            tailsConcatenated.append(tail)
                        }
                    }
                    let total = lengthEncoding + headsConcatenated + tailsConcatenated
                    //                    print("Dynamic array of dynamic types encoding :\n" + String(total.hex))
                    return total
                }
            case let .staticSize(staticLength):
                guard staticLength != 0 else { break }
                guard let val = value as? [AnyObject] else { break }
                guard staticLength == val.count else { break }
                if subType.isStatic {
                    // work in a previous context
                    var toReturn = Data()
                    for i in 0 ..< val.count {
                        let enc = encodeSingleType(type: subType, value: val[i])
                        guard let encoding = enc else { break }
                        toReturn.append(encoding)
                    }
                    //                    print("Static array of static types encoding :\n" + String(toReturn.hex))
                    let total = toReturn
                    return total
                } else {
                    // create new context
                    var tails = [Data]()
                    var heads = [Data]()
                    for i in 0 ..< val.count {
                        let enc = encodeSingleType(type: subType, value: val[i])
                        guard let encoding = enc else { return nil }
                        heads.append(Data(repeating: 0x0, count: 32))
                        tails.append(encoding)
                    }
                    var headsConcatenated = Data()
                    for h in heads {
                        headsConcatenated.append(h)
                    }
                    var tailsPointer = BigUInt(headsConcatenated.count)
                    headsConcatenated = Data()
                    var tailsConcatenated = Data()
                    for i in 0 ..< val.count {
                        let tail = tails[i]
                        guard let newHead = tailsPointer.abiEncode(bits: 256) else { return nil }
                        headsConcatenated.append(newHead)
                        tailsConcatenated.append(tail)
                        tailsPointer = tailsPointer + BigUInt(tail.count)
                    }
                    let total = headsConcatenated + tailsConcatenated
                    //                    print("Static array of dynamic types encoding :\n" + String(total.hex))
                    return total
                }
            case .notArray:
                break
            }
        case let .tuple(types: subTypes):
            var tails = [Data]()
            var heads = [Data]()
            guard let val = value as? [AnyObject] else { break }
            for i in 0 ..< subTypes.count {
                let enc = encodeSingleType(type: subTypes[i], value: val[i])
                guard let encoding = enc else { return nil }
                if subTypes[i].isStatic {
                    heads.append(encoding)
                    tails.append(Data())
                } else {
                    heads.append(Data(repeating: 0x0, count: 32))
                    tails.append(encoding)
                }
            }
            var headsConcatenated = Data()
            for h in heads {
                headsConcatenated.append(h)
            }
            var tailsPointer = BigUInt(headsConcatenated.count)
            headsConcatenated = Data()
            var tailsConcatenated = Data()
            for i in 0 ..< subTypes.count {
                let head = heads[i]
                let tail = tails[i]
                if !subTypes[i].isStatic {
                    guard let newHead = tailsPointer.abiEncode(bits: 256) else { return nil }
                    headsConcatenated.append(newHead)
                    tailsConcatenated.append(tail)
                    tailsPointer = tailsPointer + BigUInt(tail.count)
                } else {
                    headsConcatenated.append(head)
                    tailsConcatenated.append(tail)
                }
            }
            let total = headsConcatenated + tailsConcatenated
            return total
        case .function:
            if let data = value as? Data {
                return data.setLengthLeft(32)
            }
        }
        return nil
    }
}

/// Decoding functions
public struct ABIv2Decoder {
    /// Decodes solidity data to swift types
    ///
    /// - Parameters:
    ///   - types: Decoding scheme
    ///   - data: Data to decode
    /// - Returns: Array of decoded types
    public static func decode(types: [ABIv2.Element.InOut], data: Data) -> [AnyObject]? {
        let params = types.compactMap { (el) -> ABIv2.Element.ParameterType in
            return el.type
        }
        return decode(types: params, data: data)
    }

    /// Decodes solidity data to swift types
    ///
    /// - Parameters:
    ///   - types: Decoding scheme
    ///   - data: Data to decode
    /// - Returns: Array of decoded types
    public static func decode(types: [ABIv2.Element.ParameterType], data: Data) -> [AnyObject]? {
        //        print("Full data: \n" + data.hex)
        var toReturn = [AnyObject]()
        var consumed: UInt64 = 0
        for i in 0 ..< types.count {
            let (v, c) = decodeSignleType(type: types[i], data: data, pointer: consumed)
            guard let valueUnwrapped = v, let consumedUnwrapped = c else { return nil }
            toReturn.append(valueUnwrapped)
            consumed = consumed + consumedUnwrapped
        }

        guard toReturn.count == types.count else { return nil }
        return toReturn
    }

    /// Decodes single solidity type to swift type
    ///
    /// - Parameters:
    ///   - type: Decoding scheme
    ///   - data: Data to decode
    ///   - pointer: Data offset
    /// - Returns: Decoded value and bytes used to decode
    public static func decodeSignleType(type: ABIv2.Element.ParameterType, data: Data, pointer: UInt64 = 0) -> (value: AnyObject?, bytesConsumed: UInt64?) {
        let (elData, nextPtr) = followTheData(type: type, data: data, pointer: pointer)
        guard let elementItself = elData, let nextElementPointer = nextPtr else {
            return (nil, nil)
        }
        switch type {
        case let .uint(bits):
            //            print("Uint256 element itself: \n" + elementItself.hex)
            guard elementItself.count >= 32 else { break }
            let mod = BigUInt(1) << bits
            let dataSlice = elementItself[0 ..< 32]
            let v = BigUInt(dataSlice) % mod
            //            print("Uint256 element is: \n" + String(v))
            return (v as AnyObject, type.memoryUsage)
        case let .int(bits):
            //            print("Int256 element itself: \n" + elementItself.hex)
            guard elementItself.count >= 32 else { break }
            let mod = BigInt(1) << bits
            let dataSlice = elementItself[0 ..< 32]
            let v = BigInt.fromTwosComplement(data: dataSlice) % mod
            //            print("Int256 element is: \n" + String(v))
            return (v as AnyObject, type.memoryUsage)
        case .address:
            //            print("Address element itself: \n" + elementItself.hex)
            guard elementItself.count >= 32 else { break }
            let dataSlice = elementItself[12 ..< 32]
            //let address = Address(dataSlice)
            let address = Address(data: dataSlice)
            //            print("Address element is: \n" + String(address.address))
            return (address as AnyObject, type.memoryUsage)
        case .bool:
            //            print("Bool element itself: \n" + elementItself.hex)
            guard elementItself.count >= 32 else { break }
            let dataSlice = elementItself[0 ..< 32]
            let v = BigUInt(dataSlice)
            //            print("Address element is: \n" + String(v))
            if v == BigUInt(1) {
                return (true as AnyObject, type.memoryUsage)
            } else if v == BigUInt(0) {
                return (false as AnyObject, type.memoryUsage)
            }
        case let .bytes(length):
            //            print("Bytes32 element itself: \n" + elementItself.hex)
            guard elementItself.count >= 32 else { break }
            let dataSlice = elementItself[0 ..< length]
            //            print("Bytes32 element is: \n" + String(dataSlice.hex))
            return (dataSlice as AnyObject, type.memoryUsage)
        case .string:
            //            print("String element itself: \n" + elementItself.hex)
            guard elementItself.count >= 32 else { break }
            var dataSlice = elementItself[0 ..< 32]
            let length = UInt64(BigUInt(dataSlice))
            guard elementItself.count >= 32 + length else { break }
            dataSlice = elementItself[32 ..< 32 + length]
            guard let string = String(data: dataSlice, encoding: .utf8) else { break }
            //            print("String element is: \n" + String(string))
            return (string as AnyObject, type.memoryUsage)
        case .dynamicBytes:
            //            print("Bytes element itself: \n" + elementItself.hex)
            guard elementItself.count >= 32 else { break }
            var dataSlice = elementItself[0 ..< 32]
            let length = UInt64(BigUInt(dataSlice))
            guard elementItself.count >= 32 + length else { break }
            dataSlice = elementItself[32 ..< 32 + length]
            //            print("Bytes element is: \n" + String(dataSlice.hex))
            return (dataSlice as AnyObject, type.memoryUsage)
        case let .array(type: subType, length: length):
            switch type.arraySize {
            case .dynamicSize:
                //                print("Dynamic array element itself: \n" + elementItself.hex)
                if subType.isStatic {
                    // uint[] like, expect length and elements
                    guard elementItself.count >= 32 else { break }
                    var dataSlice = elementItself[0 ..< 32]
                    let length = UInt64(BigUInt(dataSlice))
                    guard elementItself.count >= 32 + subType.memoryUsage * length else { break }
                    dataSlice = elementItself[32 ..< 32 + subType.memoryUsage * length]
                    var subpointer: UInt64 = 32
                    var toReturn = [AnyObject]()
                    for _ in 0 ..< length {
                        let (v, c) = decodeSignleType(type: subType, data: elementItself, pointer: subpointer)
                        guard let valueUnwrapped = v, let consumedUnwrapped = c else { break }
                        toReturn.append(valueUnwrapped)
                        subpointer = subpointer + consumedUnwrapped
                    }
                    return (toReturn as AnyObject, type.memoryUsage)
                } else {
                    // in principle is true for tuple[], so will work for string[] too
                    guard elementItself.count >= 32 else { break }
                    var dataSlice = elementItself[0 ..< 32]
                    let length = UInt64(BigUInt(dataSlice))
                    guard elementItself.count >= 32 else { break }
                    dataSlice = Data(elementItself[32 ..< elementItself.count])
                    var subpointer: UInt64 = 0
                    var toReturn = [AnyObject]()
                    //                    print("Dynamic array sub element itself: \n" + dataSlice.hex)
                    for _ in 0 ..< length {
                        let (v, c) = decodeSignleType(type: subType, data: dataSlice, pointer: subpointer)
                        guard let valueUnwrapped = v, let consumedUnwrapped = c else { break }
                        toReturn.append(valueUnwrapped)
                        subpointer = subpointer + consumedUnwrapped
                    }
                    return (toReturn as AnyObject, nextElementPointer)
                }
            case let .staticSize(staticLength):
                //                print("Static array element itself: \n" + elementItself.hex)
                guard length == staticLength else { break }
                var toReturn = [AnyObject]()
                var consumed: UInt64 = 0
                for _ in 0 ..< length {
                    let (v, c) = decodeSignleType(type: subType, data: elementItself, pointer: consumed)
                    guard let valueUnwrapped = v, let consumedUnwrapped = c else { return (nil, nil) }
                    toReturn.append(valueUnwrapped)
                    consumed = consumed + consumedUnwrapped
                }
                if subType.isStatic {
                    return (toReturn as AnyObject, consumed)
                } else {
                    return (toReturn as AnyObject, nextElementPointer)
                }
            case .notArray:
                break
            }
        case let .tuple(types: subTypes):
            //            print("Tuple element itself: \n" + elementItself.hex)
            var toReturn = [AnyObject]()
            var consumed: UInt64 = 0
            for i in 0 ..< subTypes.count {
                let (v, c) = decodeSignleType(type: subTypes[i], data: elementItself, pointer: consumed)
                guard let valueUnwrapped = v, let consumedUnwrapped = c else { return (nil, nil) }
                toReturn.append(valueUnwrapped)
                consumed = consumed + consumedUnwrapped
            }
            //            print("Tuple element is: \n" + String(describing: toReturn))
            if type.isStatic {
                return (toReturn as AnyObject, consumed)
            } else {
                return (toReturn as AnyObject, nextElementPointer)
            }
        case .function:
            //            print("Function element itself: \n" + elementItself.hex)
            guard elementItself.count >= 32 else { break }
            let dataSlice = elementItself[8 ..< 32]
            //            print("Function element is: \n" + String(dataSlice.hex))
            return (dataSlice as AnyObject, type.memoryUsage)
        }
        return (nil, nil)
    }

    fileprivate static func followTheData(type: ABIv2.Element.ParameterType, data: Data, pointer: UInt64 = 0) -> (elementEncoding: Data?, nextElementPointer: UInt64?) {
        //        print("Follow the data: \n" + data.hex)
        //        print("At pointer: \n" + String(pointer))
        if type.isStatic {
            guard data.count >= pointer + type.memoryUsage else { return (nil, nil) }
            let elementItself = data[pointer ..< pointer + type.memoryUsage]
            let nextElement = pointer + type.memoryUsage
            //            print("Got element itself: \n" + elementItself.hex)
            //            print("Next element pointer: \n" + String(nextElement))
            return (Data(elementItself), nextElement)
        } else {
            guard data.count >= pointer + type.memoryUsage else { return (nil, nil) }
            let dataSlice = data[pointer ..< pointer + type.memoryUsage]
            let bn = BigUInt(dataSlice)
            if bn > UInt64.max || bn >= data.count {
                // there are ERC20 contracts that use bytes32 intead of string. Let's be optimistic and return some data
                if case .string = type {
                    let nextElement = pointer + type.memoryUsage
                    let preambula = BigUInt(32).abiEncode(bits: 256)!
                    return (preambula + Data(dataSlice), nextElement)
                } else if case .dynamicBytes = type {
                    let nextElement = pointer + type.memoryUsage
                    let preambula = BigUInt(32).abiEncode(bits: 256)!
                    return (preambula + Data(dataSlice), nextElement)
                }
                return (nil, nil)
            }
            let elementPointer = UInt64(bn)
            let elementItself = data[elementPointer ..< UInt64(data.count)]
            let nextElement = pointer + type.memoryUsage
            //            print("Got element itself: \n" + elementItself.hex)
            //            print("Next element pointer: \n" + String(nextElement))
            return (Data(elementItself), nextElement)
        }
    }

    /// Decodes logs to swift types
    ///
    /// - Parameters:
    ///   - event: Decoding scheme
    ///   - eventLog: Event log
    /// - Returns: Decoded logs
//    public static func decodeLog(event: ABIv2.Element.Event, eventLog: EventLog) -> [String: Any]? {
//        if event.topic != eventLog.topics[0] && !event.anonymous {
//            return nil
//        }
//        var eventContent = [String: Any]()
//        eventContent["name"] = event.name
//        let logs = eventLog.topics
//        let dataForProcessing = eventLog.data
//        let indexedInputs = event.inputs.filter { (inp) -> Bool in
//            return inp.indexed
//        }
//        if logs.count == 1 && indexedInputs.count > 0 {
//            return nil
//        }
//        let nonIndexedInputs = event.inputs.filter { (inp) -> Bool in
//            return !inp.indexed
//        }
//        let nonIndexedTypes = nonIndexedInputs.compactMap { (inp) -> ABIv2.Element.ParameterType in
//            return inp.type
//        }
//        guard logs.count == indexedInputs.count + 1 else { return nil }
//        var indexedValues = [AnyObject]()
//        for i in 0 ..< indexedInputs.count {
//            let data = logs[i + 1]
//            let input = indexedInputs[i]
//            if !input.type.isStatic || input.type.isArray || input.type.memoryUsage != 32 {
//                let (v, _) = ABIv2Decoder.decodeSignleType(type: .bytes(length: 32), data: data)
//                guard let valueUnwrapped = v else { return nil }
//                indexedValues.append(valueUnwrapped)
//            } else {
//                let (v, _) = ABIv2Decoder.decodeSignleType(type: input.type, data: data)
//                guard let valueUnwrapped = v else { return nil }
//                indexedValues.append(valueUnwrapped)
//            }
//        }
//        let v = ABIv2Decoder.decode(types: nonIndexedTypes, data: dataForProcessing)
//        guard let nonIndexedValues = v else { return nil }
//        var indexedInputCounter = 0
//        var nonIndexedInputCounter = 0
//        for i in 0 ..< event.inputs.count {
//            let el = event.inputs[i]
//            if el.indexed {
//                let name = "\(i)"
//                let value = indexedValues[indexedInputCounter]
//                eventContent[name] = value
//                if el.name != "" {
//                    eventContent[el.name] = value
//                }
//                indexedInputCounter = indexedInputCounter + 1
//            } else {
//                let name = "\(i)"
//                let value = nonIndexedValues[nonIndexedInputCounter]
//                eventContent[name] = value
//                if el.name != "" {
//                    eventContent[el.name] = value
//                }
//                nonIndexedInputCounter = nonIndexedInputCounter + 1
//            }
//        }
//        return eventContent
//    }
}
