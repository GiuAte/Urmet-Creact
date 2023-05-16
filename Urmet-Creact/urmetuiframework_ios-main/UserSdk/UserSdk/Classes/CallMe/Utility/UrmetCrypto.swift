//
//  UrmetCrypto.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 05/09/22.
//

import Foundation

final class UrmetCrypto: Crypto {
    private let KEY_POSITION = 1_498_752
    private let KEY_RANDOM_SIZE = 32

    private let key: [UInt8] = [
        0x19, 0x22, 0xF2, 0xB9, 0x66, 0x16, 0xF1, 0x90,
        0x00, 0xFF, 0xFF, 0xA9, 0x61, 0x44, 0x4F, 0x8B,
        0xE5, 0x3F, 0xF6, 0x23, 0x9B, 0xD7, 0xE0, 0x74,
        0xCA, 0x7F, 0xEC, 0x47, 0x37, 0xAF, 0xC0, 0xE8,
    ]

    // MARK: - Encrypt

    func encrypt(_ input: String) -> Data {
        let inputData = Data(input.utf8)

        return encrypt(inputData)
    }

    func encrypt(_ inputData: Data) -> Data {
        guard !inputData.isEmpty else { return Data() }

        var outputData = Data(count: inputData.count + KEY_RANDOM_SIZE)

        let keyPosition = inputData.count >= KEY_POSITION ? KEY_POSITION : inputData.count
        let randomKey = (0 ..< KEY_RANDOM_SIZE).map { _ in UInt8.random(in: 0 ..< UInt8.max) }

        encrypt(inputData, output: &outputData, from: 0, to: keyPosition, using: randomKey)

        var keyCounter = 0
        for idx in keyPosition ..< keyPosition + KEY_RANDOM_SIZE {
            outputData[idx] = randomKey[keyCounter] ^ key[keyCounter]

            keyCounter += 1
            keyCounter %= KEY_RANDOM_SIZE
        }

        encrypt(inputData, output: &outputData, from: keyPosition, to: inputData.count, using: randomKey, destinationOffset: KEY_RANDOM_SIZE)

        return outputData
    }

    private func encrypt(_ input: Data, output: inout Data, from startIndex: Int, to endIndex: Int, using key: [UInt8], destinationOffset offset: Int = 0) {
        var keyCounter = 0

        for idx in startIndex ..< endIndex {
            let byte = input[idx]

            output[idx + offset] = byte ^ key[keyCounter]

            keyCounter += 1
            keyCounter %= KEY_RANDOM_SIZE
        }
    }

    // MARK: - Decrypt

    func decrypt(_ input: Data) -> String {
        let outputData: Data = decrypt(input)

        return String(data: outputData, encoding: .utf8) ?? ""
    }

    func decrypt(_ input: Data) -> Data {
        guard !input.isEmpty else { return Data() }

        var outputData = Data()

        let keyPosition = (KEY_POSITION < input.count - KEY_RANDOM_SIZE) ? KEY_POSITION : input.count - KEY_RANDOM_SIZE
        let randomKey = (0 ..< KEY_RANDOM_SIZE).map { idx in input[keyPosition + idx] ^ key[idx] }

        decrypt(input, &outputData, from: 0, to: keyPosition, using: randomKey)
        decrypt(input, &outputData, from: keyPosition + KEY_RANDOM_SIZE, to: input.count, using: randomKey)

        return outputData
    }

    private func decrypt(_ input: Data, _ output: inout Data, from startIndex: Int, to endIndex: Int, using key: [UInt8]) {
        var keyCounter = 0

        for idx in startIndex ..< endIndex {
            let byte = input[idx] ^ key[keyCounter]

            output.append(byte)

            keyCounter += 1
            keyCounter %= KEY_RANDOM_SIZE
        }
    }
}
