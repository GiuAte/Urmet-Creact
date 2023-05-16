//
//  CryptoSwift
//
//  Copyright (C) 2014-2022 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//

/** String extension */
public extension String {
    @inlinable
    var bytes: [UInt8] {
        data(using: String.Encoding.utf8, allowLossyConversion: true)?.bytes ?? Array(utf8)
    }

    @inlinable
    func md5() -> String {
        bytes.md5().toHexString()
    }

    @inlinable
    func sha1() -> String {
        bytes.sha1().toHexString()
    }

    @inlinable
    func sha224() -> String {
        bytes.sha224().toHexString()
    }

    @inlinable
    func sha256() -> String {
        bytes.sha256().toHexString()
    }

    @inlinable
    func sha384() -> String {
        bytes.sha384().toHexString()
    }

    @inlinable
    func sha512() -> String {
        bytes.sha512().toHexString()
    }

    @inlinable
    func sha3(_ variant: SHA3.Variant) -> String {
        bytes.sha3(variant).toHexString()
    }

    @inlinable
    func crc32(seed: UInt32? = nil, reflect: Bool = true) -> String {
        bytes.crc32(seed: seed, reflect: reflect).bytes().toHexString()
    }

    @inlinable
    func crc32c(seed: UInt32? = nil, reflect: Bool = true) -> String {
        bytes.crc32c(seed: seed, reflect: reflect).bytes().toHexString()
    }

    @inlinable
    func crc16(seed: UInt16? = nil) -> String {
        bytes.crc16(seed: seed).bytes().toHexString()
    }

    /// - parameter cipher: Instance of `Cipher`
    /// - returns: hex string of bytes
    @inlinable
    func encrypt(cipher: Cipher) throws -> String {
        try bytes.encrypt(cipher: cipher).toHexString()
    }

    /// - parameter cipher: Instance of `Cipher`
    /// - returns: base64 encoded string of encrypted bytes
    @inlinable
    func encryptToBase64(cipher: Cipher) throws -> String {
        try bytes.encrypt(cipher: cipher).toBase64()
    }

    // decrypt() does not make sense for String

    /// - parameter authenticator: Instance of `Authenticator`
    /// - returns: hex string of string
    @inlinable
    func authenticate<A: Authenticator>(with authenticator: A) throws -> String {
        try bytes.authenticate(with: authenticator).toHexString()
    }
}
