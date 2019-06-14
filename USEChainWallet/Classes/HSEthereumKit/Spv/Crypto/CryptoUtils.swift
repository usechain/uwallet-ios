import Foundation
import HSCryptoKit

class CryptoUtils: ICryptoUtils {

    static let shared = CryptoUtils()

    let eciesEngine = ECIESEngine()

    func ecdhAgree(myKey: ECKey, remotePublicKeyPoint: ECPoint) -> Data {
        return CryptoKit.ecdhAgree(privateKey: myKey.privateKey, withPublicKey: remotePublicKeyPoint.uncompressed())
    }

    func ellipticSign(_ messageToSign: Data, key: ECKey) throws -> Data {
        return try CryptoKit.ellipticSign(messageToSign, privateKey: key.privateKey)
    }

    func eciesDecrypt(privateKey: Data, message: ECIESEncryptedMessage) throws -> Data {
        return try eciesEngine.decrypt(crypto: self, privateKey: privateKey, message: message)
    }

    func eciesEncrypt(remotePublicKey: ECPoint, message: Data) -> ECIESEncryptedMessage {
        return eciesEngine.encrypt(crypto: self, randomHelper: RandomHelper.shared, remotePublicKey: remotePublicKey, message: message)
    }

    func sha3(_ data: Data) -> Data {
        return CryptoKit.sha3(data)
    }

    // Stateless encryption
    func aesEncrypt(_ data: Data, withKey key: Data, keySize: Int) -> Data {
        return _AES.encrypt(data, withKey: key, keySize: keySize)
    }

}

extension CryptoUtils: IECIESCryptoUtils {

    func concatKDF(_ data: Data) -> Data {
        return _Hash.concatKDF(data)
    }

    func sha256(_ data: Data) -> Data {
        return _Hash.sha256(data)
    }

    func aesEncrypt(_ data: Data, withKey key: Data, keySize: Int, iv: Data) -> Data {
        return AESCipher(keySize: keySize, key: key, initialVector: iv).process(data)
    }

    func hmacSha256(_ data: Data, key: Data, iv: Data, macData: Data) -> Data {
        return _Hash.hmacsha256(data, key: key, iv: iv, macData: macData)
    }

    func ecdhAgree(myPrivateKey: Data, remotePublicKeyPoint: Data) -> Data {
        return CryptoKit.ecdhAgree(privateKey: myPrivateKey, withPublicKey: remotePublicKeyPoint)
    }

}
