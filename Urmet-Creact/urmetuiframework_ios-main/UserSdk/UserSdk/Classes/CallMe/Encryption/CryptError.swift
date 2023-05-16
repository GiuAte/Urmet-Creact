//
//  CryptError.swift
//  CallMeSdk
//
//  Created by Niko on 29/12/22.
//

import Foundation

public enum CryptError: Error {
    case SecKeyCreateError
    case ImpossibleReadKey
    case ErrorCreateKey
    case ErrorEncryption(_ description: String)
    case ErrorBase64Conversion
    case ErrorDataConversion
    case ErrorStringConversion
    case NotImplemented
}
