extension String {
    public func stripHexPrefix() -> String {
        var hex = self
        let prefix = "0x"
        if hex.hasPrefix(prefix) {
            hex = String(hex.dropFirst(prefix.count))
        }
        return hex
    }
    
    public func addHexPrefix() -> String {
        return "0x".appending(self)
    }
    
    public func toHexString() -> String {
        return data(using: .utf8)!.map { String(format: "%02x", $0) }.joined()
    }
}
extension String {
    var ellipsisSting: String {
        get {
            return self.count > 4 ? "\(self.substring(with: self.startIndex..<self.index(self.startIndex, offsetBy: 4)))..." : self
        }
    }
    var ellipsisMiddleSting: String {
        get {
            return self.count > 4 ? "\(self.substring(with: self.startIndex..<self.index(self.startIndex, offsetBy: 6)))...\(self.substring(with: self.index(self.endIndex, offsetBy: -6)..<self.index(self.endIndex, offsetBy: 0)))" : self
        }
    }
}

extension String {
    var htmlToString:String {
        return self.removingPercentEncoding!
    }
    // 这些都是给abi后添加的
    public var isHex: Bool {
        return hasPrefix("0x")
    }
    public var withHex: String {
        guard !isHex else { return self }
        return "0x" + self
    }
    public var withoutHex: String {
//        guard isHex else { return self }
//        return String(self[2...])
        return stripHexPrefix()
    }
    public var hex: Data {
        let string = withoutHex
        var array = [UInt8]()
        array.reserveCapacity(string.unicodeScalars.lazy.underestimatedCount)
        var buffer: UInt8?
        var skip = string.hasPrefix("0x") ? 2 : 0
        for char in string.unicodeScalars.lazy {
            guard skip == 0 else {
                skip -= 1
                continue
            }
            guard char.value >= 48 && char.value <= 102 else { return Data() }
            let v: UInt8
            let c: UInt8 = UInt8(char.value)
            switch c {
            case let c where c <= 57:
                v = c - 48
            case let c where c >= 65 && c <= 70:
                v = c - 55
            case let c where c >= 97:
                v = c - 87
            default:
                return Data()
            }
            if let b = buffer {
                array.append(b << 4 | v)
                buffer = nil
            } else {
                buffer = v
            }
        }
        if let b = buffer {
            array.append(b)
        }
        return Data(array)
    }
    
}

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
