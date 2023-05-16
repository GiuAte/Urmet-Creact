//
//  ICrypto.swift
//  CallMeSdk
//
//  Created by Niko on 29/12/22.
//

import Foundation

public typealias ICrypt = IEncrypt & IDecrypt

public protocol IEncrypt {
    func encrypt(_ input: Data) -> Result<Data, CryptError>
    func encryptToString(_ input: Data) -> Result<String, CryptError>
}

public protocol IDecrypt {
    func decrypt(_ input: Data) -> Result<Data, CryptError>
}
