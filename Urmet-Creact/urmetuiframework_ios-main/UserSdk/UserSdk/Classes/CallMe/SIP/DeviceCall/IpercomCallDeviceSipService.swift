//
//  IpercomCallDeviceSipService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 21/11/22.
//

import Foundation

final class IpercomCallDeviceSipService: IIpercomCallDeviceSipService {
    typealias DateProvider = () -> Date
    typealias MessageIdProvider = () -> Int32

    private let client: SendReceiveMessageSipClient
    private let messageFactory: ICallDeviceMessageFactory.Type
    private let messageIdProvider: MessageIdProvider
    private let dateProvider: DateProvider

    init(client: SendReceiveMessageSipClient,
         dateProvider: @escaping DateProvider = Date.init,
         messageIdProvider: @escaping MessageIdProvider = { .random(in: 0 ... Int32.max) },
         messageFactory: ICallDeviceMessageFactory.Type = CallDeviceMessageFactory.self)
    {
        self.client = client
        self.messageFactory = messageFactory
        self.dateProvider = dateProvider
        self.messageIdProvider = messageIdProvider
    }

    enum Error: Swift.Error {
        case clientError
        case invalidData
        case invalidPlace
        case unknownErrorCode
    }

    enum ResultCodeError: Int, Swift.Error {
        case unauthorized = 1
        case invalidChannel = 2
        case invalidTimestamp = 3
        case busy = 4
        case unreachable = 5
        case noSuchCall = 6
        case unableToCompleteTheOperation = 10
        case commandNotSupported = 11
        case unknownTopologicalCode = 12
        case deviceNotFound = 13
        case callTimedOut = 14
        case callRefused = 15
        case invalidParameters = 16
    }

    func call(device: Device, ofPlace place: Place, callBackUri: String, withDisplayName display_name: String, andReplyTo responseUri: String, completion: @escaping Completion) {
        guard let account = place.accounts.filter({ $0.direction == .incoming }).first,
              let gateway = place.ipercomGatewayUri
        else {
            return completion(.failure(Error.invalidPlace))
        }

        let messageId = messageIdProvider()
        let channelNumber = account.channelNumber
        let channelPassword = account.password
        let timestamp = dateProvider().timestamp
        let version = 2

        let message = messageFactory.makeCallDeviceReqMessage(messageId: messageId,
                                                              channelNumber: channelNumber,
                                                              channelPassword: channelPassword,
                                                              responseUri: responseUri,
                                                              timestamp: timestamp,
                                                              version: version,
                                                              topological_code: device.ipercomAttributes.topological_code,
                                                              display_name: display_name,
                                                              vds_types: device.ipercomAttributes.vds_types,
                                                              uri_to_call: callBackUri,
                                                              call_type: device.type.rawValue)

        client.send(message, to: gateway) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(data):
                completion(self.mapCallDevice(data))

            case .failure:
                completion(.failure(Error.clientError))
            }
        }
    }

    func cancelCall(device: Device, ofPlace place: Place, callBackUri: String, withDisplayName display_name: String, andReplyTo responseUri: String, completion: @escaping Completion) {
        guard let account = place.accounts.filter({ $0.direction == .incoming }).first,
              let gateway = place.ipercomGatewayUri
        else {
            return completion(.failure(Error.invalidPlace))
        }

        let messageId = messageIdProvider()
        let channelNumber = account.channelNumber
        let channelPassword = account.password
        let timestamp = dateProvider().timestamp
        let version = 2

        let message = messageFactory.makeCancelCallReqMessage(messageId: messageId,
                                                              channelNumber: channelNumber,
                                                              channelPassword: channelPassword,
                                                              responseUri: responseUri,
                                                              timestamp: timestamp,
                                                              version: version,
                                                              topological_code: device.ipercomAttributes.topological_code,
                                                              display_name: display_name,
                                                              vds_types: device.ipercomAttributes.vds_types,
                                                              uri_to_call: callBackUri,
                                                              call_type: device.type.rawValue)

        client.send(message, to: gateway) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(data):
                completion(self.mapCancelCall(data))

            case .failure:
                completion(.failure(Error.clientError))
            }
        }
    }
}

extension IpercomCallDeviceSipService {
    private struct Response: Decodable {
        let result: Int
        let type: String
        let version: Int
    }

    private func mapCallDevice(_ data: Data) -> IIpercomCallDeviceSipService.Result {
        guard
            let response = try? JSONDecoder().decode(Response.self, from: data),
            response.type == "call_device_resp"
        else {
            return .failure(Error.invalidData)
        }

        return mapResultCodeToResult(resultCode: response.result)
    }

    private func mapCancelCall(_ data: Data) -> IIpercomCallDeviceSipService.Result {
        guard
            let response = try? JSONDecoder().decode(Response.self, from: data),
            response.type == "cancel_call_resp"
        else {
            return .failure(Error.invalidData)
        }

        return mapResultCodeToResult(resultCode: response.result)
    }

    private func mapResultCodeToResult(resultCode: Int) -> IIpercomCallDeviceSipService.Result {
        if resultCode == 0 {
            return .success(true)
        }

        guard let err = ResultCodeError(rawValue: resultCode) else {
            return .failure(Error.unknownErrorCode)
        }

        return .failure(err)
    }
}
