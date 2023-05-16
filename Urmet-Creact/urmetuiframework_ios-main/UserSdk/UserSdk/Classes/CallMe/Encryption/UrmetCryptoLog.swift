//
//  UrmetCryptoLog.swift
//  CallMeSdk
//
//  Created by Niko on 23/12/22.
//

import Foundation

class UrmetCryptoLog: IEncrypt {
    private static let VERSION = 1
    private static let VERSION_SIZE = 2
    private static let ENCRYPTED_AES_KEY_LENGTH_SIZE = 3
    private static let AES_KEY_LENGHT = 32

    private var rsa: RSACrypt
    private let aes: AESCrypt
    private var encryptedAesKeyToBase64: String

    init(rsaPublicKey: URL) throws {
        do {
            rsa = try RSACrypt(rsaPublicKey: rsaPublicKey)
            let aesKey = AESCrypt.generateRandomKey(length: UrmetCryptoLog.AES_KEY_LENGHT)
            let aesBlockMode = AESCrypt.getBlockModeCBC()
            aes = try AESCrypt(key: aesKey, blockMode: aesBlockMode)
            encryptedAesKeyToBase64 = try rsa.encrypt(aesKey).get().base64EncodedString()
        } catch {
            throw error
        }
    }

    static func defaultUrmetEncryptor() -> IEncrypt? {
        guard let url = EncryptionUtility.URL_PEM else {
            print("No encryption instantiate")
            return nil
        }
        do {
            return try UrmetCryptoLog(rsaPublicKey: url)
        } catch {
            print("No encryption instantiate")
            return nil
        }
    }

    // MARK: encrypt

    func encryptToString(_ input: Data) -> Result<String, CryptError> {
        let versionToHex = String.makeHexStringFromInt(UrmetCryptoLog.VERSION, withLeadingZeros: UrmetCryptoLog.VERSION_SIZE)
        let encryptedAesKeyLengthToHex = String.makeHexStringFromInt(encryptedAesKeyToBase64.count, withLeadingZeros: UrmetCryptoLog.ENCRYPTED_AES_KEY_LENGTH_SIZE)
        do {
            let aesIVToBase64 = aesKeyBase64()
            let messageCrypted = try aes.encrypt(input).get()
            let messageCrytedToBase64 = messageCrypted.base64EncodedString()
            let signBase64 = try signHMACBase64(messageCrypted: messageCrypted).get()

            let finalCryptedMessage = versionToHex + encryptedAesKeyLengthToHex + encryptedAesKeyToBase64 + aesIVToBase64 + messageCrytedToBase64 + signBase64
            return .success(finalCryptedMessage)
        } catch {
            if error is CryptError {
                return .failure(error as! CryptError)
            } else {
                return .failure(.ErrorEncryption(error.localizedDescription))
            }
        }
    }

    func encrypt(_ input: Data) -> Result<Data, CryptError> {
        let result = encryptToString(input)
        switch result {
        case let .success(encryptedString):
            return EncryptionUtility.messageCryptedToData(messageCrypted: encryptedString)
        case let .failure(cryptoError):
            return .failure(cryptoError)
        }
    }

    // MARK: private

    private func aesKeyBase64() -> String {
        let aesIV = AESCrypt.generateRandomKey()
        aes.blockMode = U_CBC(iv: Array(aesIV))
        return aesIV.base64EncodedString()
    }

    private func signHMACBase64(messageCrypted: Data) -> Result<String, CryptError> {
        do {
            let sign = try HMAC.hashHMAC(key: aes.key, bytes: messageCrypted)
            let base64 = sign.base64EncodedString()
            return .success(base64)
        } catch {
            return .failure(.ErrorEncryption(error.localizedDescription))
        }
    }
}
