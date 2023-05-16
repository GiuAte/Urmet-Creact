//
//  HMAC.swift
//  CallMeSdk
//
//  Created by Niko on 29/12/22.
//

import CryptoSwift
import Foundation

typealias UrmetHMACVariant = CryptoSwift.HMAC.Variant

struct HMAC {
    static func hashHMAC(key: Data, variant: UrmetHMACVariant = .sha2(.sha256), bytes: Data) throws -> Data {
        let arrayKey: [UInt8] = Array(key)
        let arrayData: [UInt8] = Array(bytes)
        let sign = try CryptoSwift.HMAC(key: arrayKey, variant: variant).authenticate(arrayData)
        return Data(sign)
    }
}
