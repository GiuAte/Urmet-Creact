//
//  OldCfwGetMissedCallsSipService.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 27/09/22.
//

import Foundation

final class OldCfwGetMissedCallsSipService: IMissedCallsSipService {
    typealias DateProvider = () -> Date
    typealias MessageIdProvider = () -> Int32

    private let client: SendReceiveMessageSipClient
    private let messageFactory: MissedCallMessageFactory.Type
    private let messageIdProvider: MessageIdProvider
    private let dateProvider: DateProvider

    init(client: SendReceiveMessageSipClient,
         dateProvider: @escaping DateProvider = Date.init,
         messageIdProvider: @escaping MessageIdProvider = { .random(in: 0 ... Int32.max) },
         messageFactory: MissedCallMessageFactory.Type = OldCfwMissedCallsMessageFactory.self)
    {
        self.client = client
        self.messageFactory = messageFactory
        self.dateProvider = dateProvider
        self.messageIdProvider = messageIdProvider
    }

    enum Error: Swift.Error {
        case missingOutgoingAccount
        case clientError
        case invalidData
    }

    func getMissedCalls(for place: Place, andReplyTo responseUri: String, completion: @escaping Completion) {
        guard let account = place.accounts.filter({ $0.direction == .outgoing }).first else {
            return completion(.failure(Error.missingOutgoingAccount))
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

extension OldCfwGetMissedCallsSipService {
    private struct Response: Decodable {
        let id: Int
        let mac: String
        let missed_calls: [MissedCallData]
        let name: String
        let type: String

        var outputs: [MissedCall] {
            return missed_calls.map { MissedCall(
                caller: name,
                hasSnapshot: false,
                ts: convertToUNIXTime($0.time),
                ipercomAttributes: nil,
                cfwAttributes: CfwMissedCallAttributes(mac: mac)
            )
            }
        }

        private func convertToUNIXTime(_ date: String) -> UInt64 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: date)
            let timeInterval = date!.timeIntervalSince1970
            return UInt64(timeInterval)
        }
    }

    private struct MissedCallData: Decodable {
        let time: String
    }

    private func map(_ data: Data) -> OldCfwGetMissedCallsSipService.Result {
        guard
            let response = try? JSONDecoder().decode(Response.self, from: data),
            response.type == "introduction_resp"
        else { return .failure(Error.invalidData) }

        return .success(response.outputs)
    }
}
