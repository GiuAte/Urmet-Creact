//
//  CfwGetMissedCallsSipService.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 21/09/22.
//

import Foundation

final class CfwGetMissedCallsSipService: IMissedCallsSipService {
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
        case missingOutgoingAccount
    }

    func getMissedCalls(for place: Place, andReplyTo responseUri: String, completion: @escaping Completion) {
        guard let account = place.accounts.first(where: { $0.direction == .outgoing }) else {
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
                completion(self.map(data, place.name))

            case .failure:
                completion(.failure(Error.clientError))
            }
        }
    }
}

extension CfwGetMissedCallsSipService {
    private struct Response: Decodable {
        let channel: Int
        let fw_version: String
        let mac: String
        let missed_calls: [MissedCallData]
        let result: Int
        let type: String
        let version: Int

        func outputs(for placeName: String) -> [MissedCall] {
            return missed_calls.map { MissedCall(
                caller: placeName,
                hasSnapshot: false,
                ts: convertToUNIXTime($0.time),
                ipercomAttributes: nil,
                cfwAttributes: CfwMissedCallAttributes(mac: mac)
            )
            }
        }

        func convertToUNIXTime(_ date: String) -> UInt64 {
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

    private func map(_ data: Data, _ placeName: String) -> CfwGetMissedCallsSipService.Result {
        guard
            let response = try? JSONDecoder().decode(Response.self, from: data),
            response.result == 0,
            response.type == "get_missed_calls_resp"
        else { return .failure(Error.invalidData) }

        let results = response.outputs(for: placeName)
        return .success(results)
    }
}
