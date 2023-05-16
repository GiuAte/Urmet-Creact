//
//  RelationRemoverService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 14/07/22.
//

import Foundation

final class RelationRemoverService: IRelationRemoverService {
    private let client: HTTPClient
    private let baseUrl: URL

    public enum Error: Swift.Error {
        case connectivity
        case unauthorized
        case invalidData
    }

    init(client: HTTPClient, baseUrl: URL) {
        self.client = client
        self.baseUrl = baseUrl
    }

    func remove(deviceWithUID deviceId: String, andChannelId channelId: String, completion: @escaping (IRelationRemoverService.Result) -> Void) {
        let url = baseUrl
            .appendingPathComponent("/tool/callmeapi/private/remove_my_relation")
            .appendingPathComponent(deviceId)
            .appendingPathComponent(channelId)

        client.delete(atURL: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                completion(RelationRemoverService.Error.connectivity)

            case let .success((data, httpResponse)):
                completion(self.map(data, and: httpResponse))
            }
        }
    }

    private func map(_: Data, and response: HTTPURLResponse) -> IRelationRemoverService.Result {
        if response.statusCode == 401 {
            return RelationRemoverService.Error.unauthorized
        } else if response.statusCode != 200 {
            return RelationRemoverService.Error.invalidData
        }

        return nil
    }
}
