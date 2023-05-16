//
//  IdMatchingMessageSipClient.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 15/09/22.
//

import Foundation

final class IdMatchingMessageSipClient: SendReceiveMessageSipClient {
    private let sender: MessageSenderSipClient
    private var receiver: MessageReceiverSipClient
    private var completions = [Int32: Completion]()
    private let syncQueue = DispatchQueue(label: "\(IdMatchingMessageSipClient.self).queue")

    enum Error: Swift.Error {
        case messageNotDelivered
        case messageWithoutId
        case clientError
    }

    init(sender: MessageSenderSipClient, receiver: MessageReceiverSipClient) {
        self.sender = sender
        self.receiver = receiver
        self.receiver.delegate = self
    }

    func send(_ message: Data, to destinationUri: String, completion: @escaping Completion) {
        guard let messageId = getId(from: message) else {
            return completion(.failure(Error.messageWithoutId))
        }

        sender.send(message, to: destinationUri) { [weak self] senderError in
            guard let self = self else { return }

            if let _ = senderError {
                return completion(.failure(Error.messageNotDelivered))
            }

            self.syncQueue.sync {
                self.completions[messageId] = completion
            }
        }
    }

    func didReceive(message: Data) {
        syncQueue.sync {
            guard let messageId = getId(from: message) else { return }
            completions[messageId]?(.success(message))
            completions[messageId] = nil
        }
    }

    private struct MessageWithId: Decodable {
        let id: Int32
    }

    private func getId(from message: Data) -> Int32? {
        guard let m = try? JSONDecoder().decode(MessageWithId.self, from: message) else { return nil }
        return m.id
    }
}
