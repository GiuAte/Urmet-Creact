//
//  IpercomDevicesSipService.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 06/09/22.
//

import Foundation

final class IpercomGetGatewaySipService: IIpercomGetGatewaySipService {
    typealias DateProvider = () -> Date
    typealias MessageIdProvider = () -> Int32

    private let client: SendReceiveMessageSipClient
    private let dateProvider: DateProvider
    private let messageIdProvider: MessageIdProvider
    private let messageFactory: GatewayMessageFactory.Type

    init(client: SendReceiveMessageSipClient,
         dateProvider: @escaping DateProvider = Date.init,
         messageIdProvider: @escaping MessageIdProvider = { .random(in: 0 ... Int32.max) },
         messageFactory: GatewayMessageFactory.Type = IpercomGetGatewayMessageFactory.self)
    {
        self.client = client
        self.dateProvider = dateProvider
        self.messageIdProvider = messageIdProvider
        self.messageFactory = messageFactory
    }

    func getGateway(for place: Place, andReplyTo responseUri: String, completion: @escaping Completion) {
        guard place.family == .Ipercom,
              let outgoingAccount = place.accounts.first(where: { $0.direction == .outgoing }),
              let incomingAccount = place.accounts.first(where: { $0.direction == .incoming })
        else { return completion(.failure(IIpercomGetGatewaySipServiceError.invalidPlace)) }

        let messageId = messageIdProvider()
        let channelNumber = incomingAccount.channelNumber
        let channelPassword = incomingAccount.password
        let timestamp = dateProvider().timestamp
        let version = 2

        let message = messageFactory.makeMessage(messageId: messageId,
                                                 channelNumber: channelNumber,
                                                 channelPassword: channelPassword,
                                                 responseUri: responseUri,
                                                 timestamp: timestamp,
                                                 version: version)

        let destinationUri = SipUriBuilder.build(withUsername: outgoingAccount.username, andRealm: outgoingAccount.realm)

        client.send(message, to: destinationUri) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                completion(self.map(data))

            default:
                completion(.failure(IIpercomGetGatewaySipServiceError.clientError))
            }
        }
    }

    private struct Response: Decodable {
        let result: Int
        let sip_address: String
        let type: String
    }

    private func map(_ data: Data) -> IIpercomGetGatewaySipService.Result {
        guard
            let response = try? JSONDecoder().decode(Response.self, from: data),
            response.type == "get_gateway_sip_address_resp",
            response.result == 0
        else {
            return .failure(IIpercomGetGatewaySipServiceError.invalidData)
        }

        return .success(response.sip_address)
    }
}
