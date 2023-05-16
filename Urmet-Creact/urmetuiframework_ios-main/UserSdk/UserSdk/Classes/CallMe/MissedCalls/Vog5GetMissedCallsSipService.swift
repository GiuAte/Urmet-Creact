//
//  Vog5GetMissedCallsSipService.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 23/09/22.
//

import Foundation

final class Vog5GetMissedCallsSipService: IMissedCallsSipService {
    typealias DateProvider = () -> Date
    typealias MessageIdProvider = () -> Int32

    private let client: SendReceiveMessageSipClient
    private let messageFactory: MissedCallMessageFactory.Type
    private let messageIdProvider: MessageIdProvider
    private let dateProvider: DateProvider

    init(client: SendReceiveMessageSipClient,
         dateProvider: @escaping DateProvider = Date.init,
         messageIdProvider: @escaping MessageIdProvider = { .random(in: 0 ... Int32.max) },
         messageFactory: MissedCallMessageFactory.Type = GetMissedCallsMessageFactory.self)
    {
        self.client = client
        self.messageFactory = messageFactory
        self.dateProvider = dateProvider
        self.messageIdProvider = messageIdProvider
    }

    enum Error: Swift.Error {
        case clientError
        case invalidData
        case missingAccount
    }

    func getMissedCalls(for place: Place, andReplyTo responseUri: String, completion: @escaping Completion) {
        guard let account = place.accounts.filter({ $0.direction == .outgoing }).first else {
            return completion(.failure(Error.missingAccount))
        }

        let messageId = messageIdProvider()
        let channelNumber = account.channelNumber
        let channelPassword = account.password
        let timestamp = dateProvider().timestamp
        let version = 2

        let message = messageFactory.makeMessage(
            messageId: messageId,
            channelNumber: channelNumber,
            channelPassword: channelPassword,
            responseUri: responseUri,
            timestamp: timestamp,
            version: version
        )

        let destinationUri = SipUriBuilder.build(withUsername: account.username, andRealm: account.realm)

        client.send(message, to: destinationUri) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(data):
                completion(self.map(data))

            case .failure:
                completion(.failure(Error.clientError))
            }
        }
    }
}

extension Vog5GetMissedCallsSipService {
    private struct Response: Decodable {
        let id: Int
        let mac: String
        let missed_calls: [MissedCallData]
        let name: String
        let result: Int
        let snapshot_enabled: Bool
        let type: String
        let version: Int

        var outputs: [MissedCall] {
            return missed_calls.map { MissedCall(
                caller: name,
                hasSnapshot: $0.skip_snaphot == 1,
                ts: UInt64($0.ts),
                ipercomAttributes: nil,
                cfwAttributes: CfwMissedCallAttributes(mac: mac)
            )
            }
        }
    }

    private struct MissedCallData: Decodable {
        let skip_snaphot: Int
        let ts: Int
    }

    private func map(_ data: Data) -> Vog5GetMissedCallsSipService.Result {
        guard
            let response = try? JSONDecoder().decode(Response.self, from: data),
            response.result == 0,
            response.type == "get_missed_calls_resp"
        else { return .failure(Error.invalidData) }

        return .success(response.outputs)
    }
}
