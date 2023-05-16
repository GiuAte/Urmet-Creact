//
//  GetSharedUsers.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 22/07/22.
//

import Foundation

final class GetSharedUsersService: IGetSharedUsersService {
    enum Error: Swift.Error {
        case connectivity
        case unauthorized
        case invalidData
        case invalidPlace
    }

    private struct ResponseRoot: Decodable {
        let data: [PlaceUser]
    }

    private let client: HTTPClient
    private let baseUrl: URL

    init(client: HTTPClient, baseUrl: URL) {
        self.client = client
        self.baseUrl = baseUrl
    }

    func get(forPlace place: Place, completion: @escaping (IGetSharedUsersService.Result) -> Void) {
        guard let channelId = Place.extractSIPIncomingUsername(place: place),
              let uid = place.uid
        else {
            return completion(.failure(GetSharedUsersService.Error.invalidPlace))
        }

        let url = baseUrl
            .appendingPathComponent("/tool/callmeapi/private/get_sharing_users")
            .appendingPathComponent(uid)
            .appendingPathComponent(channelId)

        client.get(fromURL: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                completion(.failure(GetSharedUsersService.Error.connectivity))

            case let .success((data, httpResponse)):
                completion(self.map(data, and: httpResponse, andChannel: channelId))
            }
        }
    }

    private func map(_ data: Data, and response: HTTPURLResponse, andChannel channelId: String) -> IGetSharedUsersService.Result {
        if response.statusCode == 401 {
            return .failure(GetSharedUsersService.Error.unauthorized)
        }

        guard
            response.statusCode == 200,
            let root = try? JSONDecoder().decode(ResponseRoot.self, from: data)
        else { return .failure(GetSharedUsersService.Error.invalidData) }

        let users: [PlaceUser] = root.data.map {
            PlaceUser(
                name: $0.name,
                surname: $0.surname,
                relationType: $0.relation_type,
                sharingPermission: $0.isSharable,
                userId: $0.userid,
                channelId: channelId
            )
        }

        return .success(users)
    }
}
