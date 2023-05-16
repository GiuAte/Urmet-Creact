//
//  AddChannelsToDeviceService.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 05/07/22.
//

import Foundation

final class AddChannelsToDeviceService {
    typealias Completion = (Result) -> Void
    typealias Result = Swift.Result<Bool, Error>

    enum Error: Swift.Error {
        case unauthorized
        case connectivity
        case invalidData
    }

    private let client: HTTPClient
    private let baseURL: URL

    private let Ok = 200
    private let Unauthorized = 401

    private struct ChannelData: Encodable {
        let channel_number: Int
    }

    private struct Request: Encodable {
        let device_id: String
        let model: String
        let set_ownership: Bool
        let list_of_channels: [ChannelData]
    }

    private struct ResponseChannel: Decodable {
        let channel_number: Int
    }

    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }

    func add(channels: [Int], toDeviceWithId deviceId: String, model: String, ownership: Bool, completion: @escaping Completion) {
        let url = baseURL.appendingPathComponent("tool/callmeapi/private/add_channels_to_device/")
        let listOfChannels = channels.map { ChannelData(channel_number: $0) }
        let request = Request(device_id: deviceId, model: model, set_ownership: ownership, list_of_channels: listOfChannels)
        let body = try! JSONEncoder().encode(request)

        client.post(toURL: url, withHeaders: [:], andBody: body) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success((data, httpResponse)):
                completion(self.map(data, httpResponse))

            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }

    private func map(_: Data, _ httpResponse: HTTPURLResponse) -> Result {
        if httpResponse.statusCode == Unauthorized {
            return .failure(.unauthorized)
        }
        guard httpResponse.statusCode == Ok else {
            return .failure(.invalidData)
        }

        return .success(true)
    }
}
