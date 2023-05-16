//
//  EncriptionUtility.swift
//  CallMeSdk
//
//  Created by Niko on 30/12/22.
//

import Foundation

struct EncryptionUtility {
    static let URL_PEM = Bundle(for: Sdk.self).url(forResource: "log_public_key", withExtension: "pem")

    static func messageCryptedToString(messageCrypted: Data) -> Result<String, CryptError> {
        guard let string = String(data: messageCrypted, encoding: .utf8) else {
            return .failure(.ErrorStringConversion)
        }
        return .success(string)
    }

    static func messageCryptedToData(messageCrypted: String) -> Result<Data, CryptError> {
        guard let dataMessage = messageCrypted.data(using: .utf8) else {
            return .failure(.ErrorDataConversion)
        }
        return .success(dataMessage)
    }
}
