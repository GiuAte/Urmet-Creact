//
//  SharingTokenGeneratorService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 26/07/22.
//

import Foundation

final class SharingTokenGeneratorService: ISharingTokenGeneratorService {
    enum Error: Swift.Error {
        case invalidPlaceUser
        case connectivity
        case unauthorized
        case invalidData
    }

    private struct ResponseRoot: Decodable {
        let data: SharingTokenResponse
    }

    private struct SharingTokenResponse: Decodable {
        let sharing_token: String
    }

    private let client: HTTPClient
    private let baseUrl: URL

    private let resourcePath = "/tool/callmeapi/private/get_sharing_token/"

    init(client: HTTPClient, baseUrl: URL) {
        self.client = client
        self.baseUrl = baseUrl
    }

    func generate(asPlaceUser user: PlaceUser, completion: @escaping ISharingTokenGeneratorService.Completion) {
        guard
            user.isOwner,
            user.isSharable,
            let channelId = user.channelId
        else {
            return completion(.failure(SharingTokenGeneratorService.Error.invalidPlaceUser))
        }

        let url = baseUrl
            .appendingPathComponent(resourcePath)
            .appendingPathComponent(channelId)

        client.get(fromURL: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                completion(.failure(SharingTokenGeneratorService.Error.connectivity))

            case let .success((data, httpResponse)):
                completion(self.map(data, httpResponse, completeName: user.completeName))
            }
        }
    }

    private func map(_ data: Data, _ httpResponse: HTTPURLResponse, completeName: String) -> ISharingTokenGeneratorService.Result {
        if httpResponse.statusCode == 401 {
            return .failure(SharingTokenGeneratorService.Error.unauthorized)
        }

        guard
            httpResponse.statusCode == 200,
            let response = try? JSONDecoder().decode(ResponseRoot.self, from: data)
        else {
            return .failure(SharingTokenGeneratorService.Error.invalidData)
        }

        return .success(SharingToken(completeName: completeName, token: response.data.sharing_token, model: "1083/83"))
    }
}
