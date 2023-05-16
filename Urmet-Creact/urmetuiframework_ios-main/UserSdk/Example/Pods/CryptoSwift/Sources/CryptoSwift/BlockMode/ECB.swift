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

//  Electronic codebook (ECB)
//

public struct ECB: BlockMode {
    public let options: BlockModeOption = .paddingRequired
    public let customBlockSize: Int? = nil

    public init() {}

    public func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock, encryptionOperation _: @escaping CipherOperationOnBlock) throws -> CipherModeWorker {
        ECBModeWorker(blockSize: blockSize, cipherOperation: cipherOperation)
    }
}

struct ECBModeWorker: BlockModeWorker {
    typealias Element = [UInt8]
    let cipherOperation: CipherOperationOnBlock
    let blockSize: Int
    let additionalBufferSize: Int = 0

    init(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock) {
        self.blockSize = blockSize
        self.cipherOperation = cipherOperation
    }

    @inlinable
    mutating func encrypt(block plaintext: ArraySlice<UInt8>) -> [UInt8] {
        guard let ciphertext = cipherOperation(plaintext) else {
            return Array(plaintext)
        }
        return ciphertext
    }

    mutating func decrypt(block ciphertext: ArraySlice<UInt8>) -> [UInt8] {
        encrypt(block: ciphertext)
    }
}
