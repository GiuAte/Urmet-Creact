//
//  IpercomGetMissedCallsSipService.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 16/09/22.
//

import Foundation

final class IpercomGetMissedCallsSipService: IMissedCallsSipService {
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
        guard let account = place.accounts.filter({ $0.direction == .incoming }).first,
              let destinationUri = place.ipercomGatewayUri
        else {
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

extension IpercomGetMissedCallsSipService {
    private struct Response: Decodable {
        let channel: Int
        let id: Int
        let missed_calls: [MissedCallData]
        let result: Int
        let type: String
        let uid: String
        let version: Int

        var outputs: [MissedCall] {
            return missed_calls.map { MissedCall(
                caller: $0.caller,
                hasSnapshot: !$0.image_url.isEmpty,
                ts: UInt64($0.ts),
                ipercomAttributes: IpercomMissedCallAttributes(
                    call_type: $0.call_type,
                    caller_code: $0.caller_code
                ),
                cfwAttributes: nil
            )
            }
        }
    }

    private struct MissedCallData: Decodable {
        let call_type: String
        let caller: String
        let caller_code: String
        let image_url: String
        let time: String
        let ts: Int
    }

    private func map(_ data: Data) -> IpercomGetMissedCallsSipService.Result {
        guard
            let response = try? JSONDecoder().decode(Response.self, from: data),
            response.result == 0,
            response.type == "get_missed_calls_resp"
        else { return .failure(Error.invalidData) }

        return .success(response.outputs)
    }
}
