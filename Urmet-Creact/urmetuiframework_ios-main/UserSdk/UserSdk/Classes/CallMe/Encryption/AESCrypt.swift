//
//  AESCrypt.swift
//  CallMeSdk
//
//  Created by Niko on 23/12/22.
//

import CommonCrypto
import CryptoSwift
import Foundation

typealias UBlockMode = BlockMode
typealias UPadding = Padding
typealias U_CBC = CBC

class AESCrypt: ICrypt {
    private static let AES_IV_KEY_LENGTH = 16
    private var _key: [UInt8] = Array()
    var blockMode: UBlockMode = AESCrypt.getBlockModeCBC()
    var padding: UPadding = .pkcs5

    var key: Data {
        get {
            return Data(_key)
        }

        set(newValue) {
            _key = Array(newValue)
        }
    }

    init(key: Data, blockMode: UBlockMode, padding: UPadding = .pkcs5) throws {
        self.key = key
        self.blockMode = blockMode
        self.padding = padding
    }

    // MARK: IEncrypt

    func encrypt(_ input: Data) -> Result<Data, CryptError> {
        let arrayValues = ArraySlice(input)
        do {
            let cryptedArray = try AES(key: _key, blockMode: blockMode, padding: padding).encrypt(arrayValues)
            return .success(Data(cryptedArray))
        } catch {
            return .failure(.ErrorEncryption(error.localizedDescription))
        }
    }

    func encryptToString(_ input: Data) -> Result<String, CryptError> {
        let result = encrypt(input)
        switch result {
        case let .success(cryptedMessage):
            return EncryptionUtility.messageCryptedToString(messageCrypted: cryptedMessage)
        case let .failure(cryptoError):
            return .failure(cryptoError)
        }
    }

    // MARK: IDecrypt

    func decrypt(_: Data) -> Result<Data, CryptError> {
        return .failure(.NotImplemented)
    }

    // MARK: Public

    static func generateRandomKey(length: Int = AESCrypt.AES_IV_KEY_LENGTH) -> Data {
        let arrayKey = AES.randomIV(length)
        return Data(arrayKey)
    }

    static func getBlockModeCBC(_ length: Int = AESCrypt.AES_IV_KEY_LENGTH) -> UBlockMode {
        let keyRandom = AESCrypt.generateRandomKey(length: length)
        return CBC(iv: Array(keyRandom))
    }
}
