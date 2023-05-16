//
//  SetChannelFlagsService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 04/07/22.
//

import Foundation

final class SetChannelFlagsService {
    typealias Result = Error?

    public enum Error: Swift.Error {
        case connectivity
        case unauthorized
        case invalidData
    }

    private let baseUrl: URL
    private let client: HTTPClient

    init(client: HTTPClient, baseUrl: URL) {
        self.baseUrl = baseUrl
        self.client = client
    }

    func set(forUID uid: String, andChannel channel: Int, withFlags flags: UInt64, completion: @escaping (Result) -> Void) {
        let url = baseUrl
            .appendingPathComponent("tool/callmeapi/private/set_channel_flags")
            .appendingPathComponent(uid)
            .appendingPathComponent(String(channel))
            .appendingPathComponent(String(flags))
        client.post(toURL: url, withHeaders: [:], andBody: Data()) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                completion(.connectivity)

            case let .success((data, httpResponse)):
                return completion(self.map(data, and: httpResponse))
            }
        }
    }

    private func map(_: Data, and response: HTTPURLResponse) -> SetChannelFlagsService.Result {
        if response.statusCode == 401 {
            return .unauthorized
        }

        if response.statusCode != 200 {
            return .invalidData
        }

        return nil
    }
}
