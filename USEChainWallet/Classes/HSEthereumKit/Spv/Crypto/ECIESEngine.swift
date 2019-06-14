import Foundation


class ECIESEngine {

    enum ECIESError : Error {
        case macMismatch
    }

    // 128 bit EC public key, IV, 256 bit MAC
    static let prefix = 65 + 128 / 8 + 32

    func encrypt(crypto: IECIESCryptoUtils, randomHelper: IRandomHelper, remotePublicKey: ECPoint, message: Data) -> ECIESEncryptedMessage {
        // s1 is fed into key derivation, s2 is fed into the MAC
        // 校验用的 这个东西有点类似于 以太坊中的s1 s2
        let prefix = UInt16(ECIESEngine.prefix + message.count)
        let prefixBytes = Data(prefix.data.reversed())
        // 随机一个iv
        let initialVector = randomHelper.randomBytes(length: 16)
        // 随机生成一个私钥
        let ephemeralKey = randomHelper.randomKey()
        // 用随机生成的私钥 乘以 传进来的公钥--->生成共享秘钥z
        let sharedSecret = crypto.ecdhAgree(myKey: ephemeralKey, remotePublicKeyPoint: remotePublicKey)
        // 用共享秘钥算出衍生秘钥K
        let derivedKey = crypto.concatKDF(sharedSecret)
        // 衍生秘钥一分为二
        // 一个是Ke作为AES的加密秘钥
        let aesKey = derivedKey.subdata(in: 0..<16)
        // 一个是Km作为mac的加密秘钥
        let macKey = crypto.sha256(derivedKey.subdata(in: 16..<32))
        // AES-CTR算密文
        // em, err := symEncrypt(rand, params, Ke, m)
        // rand->iv; params->keySize; Ke->aseKey; m->message;
        let cipher = crypto.aesEncrypt(message, withKey: aesKey, keySize: 128, iv: initialVector)
        // d := messageTag(params.Hash, Km, em, s2)
        // s2 is fed into the MAC
        // checksum对应d params.hash->hmacSha256; Km->macKey; em->cipher; s2->prefixBytes
        let checksum = crypto.hmacSha256(cipher, key: macKey, iv: initialVector, macData: NSData() as Data)
        // 最后返回的结果(以太坊go实现中)
        // copy(ct, Rb) copy(ct[len(Rb):], em) copy(ct[len(Rb)+len(em):], d)
        // Rb + em + d ==> ephemeralKey + cipher + checksum
        return ECIESEncryptedMessage(prefixBytes: prefixBytes, ephemeralPublicKey: ephemeralKey.publicKeyPoint.uncompressed(), initialVector: initialVector, cipher: cipher, checksum: checksum)
    }

    func decrypt(crypto: IECIESCryptoUtils, privateKey: Data, message: ECIESEncryptedMessage) throws -> Data {
        let sharedSecret = crypto.ecdhAgree(myPrivateKey: privateKey, remotePublicKeyPoint: message.ephemeralPublicKey)
        let derivedKey = crypto.concatKDF(sharedSecret)
        let aesKey = derivedKey.subdata(in: 0..<16)
        let macKey = crypto.sha256(derivedKey.subdata(in: 16..<32))

        let decryptedMessage = crypto.aesEncrypt(message.cipher, withKey: aesKey, keySize: 128, iv: message.initialVector)
        
        // 关闭校验
//        let checksumCalculated = crypto.hmacSha256(message.cipher, key: macKey, iv: message.initialVector, macData: message.prefixBytes)
//
//        guard message.checksum == checksumCalculated else {
//            throw ECIESError.macMismatch
//        }

        return decryptedMessage
    }

}
