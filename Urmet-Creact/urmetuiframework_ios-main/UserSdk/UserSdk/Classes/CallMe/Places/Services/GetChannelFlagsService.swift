//
//  GetChannelFlagsService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 05/07/22.
//

import Foundation

final class GetChannelFlagsService {
    typealias Result = Swift.Result<ChannelFlags, Error>

    public enum Error: Swift.Error {
        case connectivity
        case unauthorized
        case invalidData
    }

    private struct ResponseRoot: Decodable {
        let data: ChannelFlags

        var channelFlags: ChannelFlags {
            return data
        }
    }

    private let baseUrl: URL
    private let client: HTTPClient

    init(client: HTTPClient, baseUrl: URL) {
        self.baseUrl = baseUrl
        self.client = client
    }

    func get(forUID uid: String, andChannel channel: Int, completion: @escaping (Result) -> Void) {
        let url = baseUrl
            .appendingPathComponent("tool/callmeapi/private/get_channel_flags")
            .appendingPathComponent(uid)
            .appendingPathComponent(String(channel))
        client.get(fromURL: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                completion(.failure(.connectivity))

            case let .success((data, httpResponse)):
                completion(self.map(data, and: httpResponse))
            }
        }
    }

    private func map(_ data: Data, and response: HTTPURLResponse) -> GetChannelFlagsService.Result {
        if response.statusCode == 401 {
            return .failure(.unauthorized)
        }

        if response.statusCode != 200 {
            return .failure(.invalidData)
        }

        guard
            response.statusCode == 200,
            let root = try? JSONDecoder().decode(ResponseRoot.self, from: data)
        else { return .failure(.invalidData) }

        return .success(root.channelFlags)
    }
}
