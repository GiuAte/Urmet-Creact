//
//  CryptoLogFactory.swift
//  CallMeSdk
//
//  Created by Niko on 12/01/23.
//

import Foundation

public class CryptoLogFactory {
    public static let shared: CryptoLogFactory = .init()

    public func createCryptoLog(rsaPublicKey: URL) throws -> IEncrypt? {
        return try UrmetCryptoLog(rsaPublicKey: rsaPublicKey)
    }
}
