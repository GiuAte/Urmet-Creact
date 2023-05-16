//
//  String+Crypt.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 06/09/22.
//

import CommonCrypto
import Foundation

public extension String {
    var sha1: String {
        let data = Data(utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
