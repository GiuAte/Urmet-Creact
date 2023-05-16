//
//  IpercomGetDevicesSipService.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 13/09/22.
//

import Foundation

final class IpercomGetDevicesSipService: IGetDevicesSipService {
    typealias DateProvider = () -> Date
    typealias MessageIdProvider = () -> Int32

    private let client: SendReceiveMessageSipClient
    private let messageFactory: DeviceMessageFactory.Type
    private let messageIdProvider: MessageIdProvider
    private let dateProvider: DateProvider

    init(client: SendReceiveMessageSipClient,
         dateProvider: @escaping DateProvider = Date.init,
         messageIdProvider: @escaping MessageIdProvider = { .random(in: 0 ... Int32.max) },
         messageFactory: DeviceMessageFactory.Type = IpercomGetDevicesMessageFactory.self)
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

    func getDevices(for place: Place, andReplyTo responseUri: String, completion: @escaping Completion) {
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

extension IpercomGetDevicesSipService {
    private struct Response: Decodable {
        private let devices: [DeviceData]
        let result: Int
        let type: String
        let version: Int

        var outputs: [Device] {
            return devices.map {
                Device(
                    name: $0.name,
                    type: $0.call_type,
                    ipercomAttributes: IpercomDeviceAttributes(
                        topological_code: $0.topological_code,
                        vds_types: $0.vds_types
                    )
                )
            }
        }
    }

    private struct DeviceData: Decodable {
        let name: String
        let call_type: DeviceType
        let topological_code: String
        let vds_types: String
    }

    private func map(_ data: Data) -> IGetDevicesSipService.Result {
        guard
            let response = try? JSONDecoder().decode(Response.self, from: data),
            response.result == 0,
            response.type == "get_available_devices_resp"
        else { return .failure(Error.invalidData) }

        return .success(response.outputs)
    }
}
