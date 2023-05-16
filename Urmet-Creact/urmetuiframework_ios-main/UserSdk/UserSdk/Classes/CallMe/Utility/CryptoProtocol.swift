//
//  CryptoProtocol.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 06/09/22.
//

import Foundation

protocol Crypto {
    func encrypt(_ input: Data) -> Data
    func encrypt(_ input: String) -> Data

    func decrypt(_ input: Data) -> String
    func decrypt(_ input: Data) -> Data
}
