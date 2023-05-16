//
//  TCPClientWithCryptoDecorator.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 17/10/22.
//

import Foundation

final class TCPClientWithCryptoDecorator: TCPClient {
    private let client: TCPClient
    private let crypto: Crypto

    init(client: TCPClient, crypto: Crypto) {
        self.client = client
        self.crypto = crypto
    }

    func openConnection(completion: @escaping OpenConnectionCompletion) {
        client.openConnection(completion: completion)
    }

    func closeConnection(completion: @escaping CloseConnectionCompletion) {
        client.closeConnection(completion: completion)
    }

    func write(_ data: Data, completion: @escaping WriteCompletion) {
        client.write(crypto.encrypt(data), completion: completion)
    }

    func read(completion: @escaping ReadCompletion) {
        client.read { [weak self] result in
            guard let self = self else { return }
            guard let encryptedData: Data = try? result.get() else {
                return completion(result)
            }
            completion(.success(self.crypto.decrypt(encryptedData)))
        }
    }
}
