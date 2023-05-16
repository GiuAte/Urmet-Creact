//
//  RSACrypt.swift
//  CallMeSdk
//
//  Created by Niko on 23/12/22.
//

import CryptoSwift
import Foundation

class RSACrypt: ICrypt {
    let rsa: RSA

    init(rsaPublicKey: URL) throws {
        let result = RSACrypt.getRSAKey(keyUrl: rsaPublicKey, isPrivate: false)
        switch result {
        case let .success(key):
            rsa = key
        case let .failure(cryptoError):
            print(cryptoError.localizedDescription)
            throw cryptoError
        }
    }

    // MARK: IEncrypt

    func encrypt(_ input: Data) -> Result<Data, CryptError> {
        let arrayValues = ArraySlice(input)
        do {
            let cryptedArray = try rsa.encrypt(arrayValues)
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
        // TODO: To be implement
        return .failure(.NotImplemented)
    }

    // MARK: private

    private static func getRSAKey(keyUrl: URL, isPrivate: Bool) -> Result<RSA, CryptError> {
        let result = decodeSecKeyFromFile(keyUrl: keyUrl, isPrivate: isPrivate)
        let rsaSecKey: SecKey
        switch result {
        case let .success(secKey):
            rsaSecKey = secKey
        case let .failure(cryptoError):
            return .failure(cryptoError)
        }

        var externalRepError: Unmanaged<CFError>?
        guard let cfdata = SecKeyCopyExternalRepresentation(rsaSecKey, &externalRepError) else {
            return .failure(.ImpossibleReadKey)
        }

        do {
            let rsaKey = try RSA(rawRepresentation: cfdata as Data)
            return .success(rsaKey)
        } catch {
            return .failure(.ErrorCreateKey)
        }
    }

    private static func decodeSecKeyFromFile(keyUrl: URL, isPrivate: Bool) -> Result<SecKey, CryptError> {
        var keyClass = kSecAttrKeyClassPublic
        if isPrivate {
            keyClass = kSecAttrKeyClassPrivate
        }

        let keyString: String
        do {
            keyString = try String(contentsOf: keyUrl)
        } catch {
            return .failure(.ImpossibleReadKey)
        }
        let pem = removeHeaderFooterFromKey(keyString)
        let der = Data(base64Encoded: pem, options: .ignoreUnknownCharacters)!
        let attributes = getKeyAttributes(keyClass: keyClass, derCount: der.count)
        var error: Unmanaged<CFError>?

        guard let secKey = SecKeyCreateWithData(der as CFData, attributes as CFDictionary, &error) else {
            let e = error!.takeRetainedValue() as Error
            print(e.localizedDescription)
            return .failure(.SecKeyCreateError)
        }

        return .success(secKey)
    }

    private static func getKeyAttributes(keyClass: CFString, derCount: Int) -> CFDictionary {
        let attributes: [String: Any] =
            [
                String(kSecAttrKeyType): kSecAttrKeyTypeRSA,
                String(kSecAttrKeyClass): keyClass,
                String(kSecAttrKeySizeInBits): derCount * 8,
            ]
        return attributes as CFDictionary
    }

    private static func removeHeaderFooterFromKey(_ originalString: String) -> String {
        do {
            let regexHeaderFooter = try NSRegularExpression(pattern: "[-]{5}+[A-Z,a-z,0-9, ]*+[-]{5}")
            let mutableString = NSMutableString(string: originalString)
            _ = regexHeaderFooter.replaceMatches(in: mutableString, range: NSMakeRange(0, mutableString.length), withTemplate: "")
            return String(mutableString)
        } catch {
            return ""
        }
    }
}
