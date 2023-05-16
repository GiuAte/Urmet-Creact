//
//  SetNewSharingService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 05/07/22.
//

import Foundation

final class SetNewSharingService {
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

    func set(newSharingFromToken token: String, completion: @escaping (Result) -> Void) {
        let url = baseUrl
            .appendingPathComponent("tool/callmeapi/private/set_new_sharing")
            .appendingPathComponent(token)
        client.post(toURL: url, withHeaders: [:], andBody: Data()) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                completion(.connectivity)

            case let .success((data, httpResponse)):
                completion(self.map(data, and: httpResponse))
            }
        }
    }

    private func map(_: Data, and response: HTTPURLResponse) -> SetNewSharingService.Result {
        if response.statusCode == 401 {
            return .unauthorized
        } else if response.statusCode != 200 {
            return .invalidData
        }

        return nil
    }
}
