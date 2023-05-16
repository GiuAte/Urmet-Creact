//
//  DeleteSharedUserService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 22/07/22.
//

import Foundation

final class DeleteSharedUserService: IDeleteSharedUserService {
    enum Error: Swift.Error {
        case connectivity
        case unauthorized
        case invalidData
        case invalidPlaceUser
    }

    private let baseUrl: URL
    private let client: HTTPClient

    init(client: HTTPClient, baseUrl: URL) {
        self.client = client
        self.baseUrl = baseUrl
    }

    func delete(placeUser: PlaceUser, completion: @escaping (IDeleteSharedUserService.Result) -> Void) {
        guard let channelId = placeUser.channelId else { return completion(DeleteSharedUserService.Error.invalidPlaceUser) }
        let url = baseUrl
            .appendingPathComponent("/tool/callmeapi/private/remove_sharing")
            .appendingPathComponent(channelId)
            .appendingPathComponent(placeUser.userid)

        client.delete(atURL: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                return completion(DeleteSharedUserService.Error.connectivity)

            case let .success((data, httpResponse)):
                completion(self.map(data, and: httpResponse))
            }
        }
    }

    private func map(_: Data, and response: HTTPURLResponse) -> DeleteSharedUserService.Result {
        if response.statusCode == 401 {
            return DeleteSharedUserService.Error.unauthorized
        } else if response.statusCode != 200 {
            return DeleteSharedUserService.Error.invalidData
        }

        return nil
    }
}
