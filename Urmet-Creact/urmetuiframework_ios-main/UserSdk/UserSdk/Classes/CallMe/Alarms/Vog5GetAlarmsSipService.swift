//
//  Vog5GetAlarmsSipService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 12/10/22.
//

import Foundation

final class Vog5GetAlarmsSipService: IGetAlarmsSipService {
    typealias DateProvider = () -> Date
    typealias MessageIdProvider = () -> Int32

    enum Error: Swift.Error {
        case clientError
        case invalidData
        case missingAccount
    }

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

    func getAlarms(for place: Place, andReplyTo responseUri: String, completion: @escaping Completion) {
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

    private struct Response: Decodable {
        let alarms: [AlarmData]
        let result: Int
        let type: String
        let version: Int
        let uid: String
        let channel: Int
    }

    private struct AlarmData: Decodable {
        let state: AlarmState
        let ts: Int
        let type: AlarmType
    }

    private func map(_ data: Data) -> IGetAlarmsSipService.Result {
        guard
            let response = try? JSONDecoder().decode(Response.self, from: data),
            response.result == 0,
            response.type == "get_alarms_resp"
        else { return .failure(Error.invalidData) }

        return .success(map(alarmsData: response.alarms))
    }

    private func map(alarmsData: [AlarmData]) -> [Alarm] {
        return alarmsData.map {
            Alarm(sender: nil,
                  state: $0.state,
                  ts: UInt64($0.ts),
                  type: $0.type,
                  ipercomAttributes: nil,
                  cfwAttributes: nil)
        }
    }
}
