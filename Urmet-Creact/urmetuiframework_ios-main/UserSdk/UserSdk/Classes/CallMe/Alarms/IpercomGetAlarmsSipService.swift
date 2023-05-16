//
//  IpercomGetAlarmsSipService.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 19/09/22.
//

import Foundation

final class IpercomGetAlarmsSipService: IGetAlarmsSipService {
    typealias DateProvider = () -> Date
    typealias MessageIdProvider = () -> Int32

    private let client: SendReceiveMessageSipClient
    private let messageFactory: AlarmMessageFactory.Type
    private let messageIdProvider: MessageIdProvider
    private let dateProvider: DateProvider

    init(client: SendReceiveMessageSipClient,
         dateProvider: @escaping DateProvider = Date.init,
         messageIdProvider: @escaping MessageIdProvider = { .random(in: 0 ... Int32.max) },
         messageFactory: AlarmMessageFactory.Type = GetAlarmsMessageFactory.self)
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

    func getAlarms(for place: Place, andReplyTo responseUri: String, completion: @escaping Completion) {
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

extension IpercomGetAlarmsSipService {
    private struct Response: Decodable {
        private let alarms: [AlarmData]
        let result: Int
        let type: String
        let version: Int

        var outputs: [Alarm] {
            return alarms.map { Alarm(
                sender: $0.sender,
                state: $0.state,
                ts: UInt64($0.ts),
                type: $0.type,
                ipercomAttributes: IpercomAlarmAttributes(
                    topological_code: $0.topological_code,
                    vds_types: $0.vds_types
                ),
                cfwAttributes: nil
            )
            }
        }
    }

    private struct AlarmData: Decodable {
        let sender: String
        let state: AlarmState
        let topological_code: String
        let ts: Int
        let type: AlarmType
        let vds_types: String
    }

    private func map(_ data: Data) -> IGetAlarmsSipService.Result {
        guard
            let response = try? JSONDecoder().decode(Response.self, from: data),
            response.result == 0,
            response.type == "get_alarms_resp"
        else { return .failure(Error.invalidData) }

        return .success(response.outputs)
    }
}
