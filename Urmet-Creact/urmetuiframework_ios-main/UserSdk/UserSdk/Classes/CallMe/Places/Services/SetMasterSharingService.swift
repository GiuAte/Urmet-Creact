//
//  SetMasterSharingService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 04/07/22.
//

import Foundation

final class SetMasterSharingService {
    typealias Result = Error?

    private let baseUrl: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case unauthorized
        case invalidData
        case masterAlreadySet
    }

    private struct Request: Encodable {
        let uid: String
        let channel_name: String
        let channel_number: Int
    }

    init(client: HTTPClient, baseUrl: URL) {
        self.baseUrl = baseUrl
        self.client = client
    }

    func set(withChannel channel: Int, deviceUID uid: String, relationName: String, completion: @escaping (Result) -> Void) {
        let url = baseUrl.appendingPathComponent("tool/callmeapi/private/set_master_sharing_UID_channel_number/")

        let request = Request(uid: uid, channel_name: relationName, channel_number: channel)
        let requestBody = try! JSONEncoder().encode(request)

        client.post(toURL: url, withHeaders: [:], andBody: requestBody) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                return completion(.connectivity)

            case let .success((data, httpResponse)):
                return completion(self.map(data, and: httpResponse))
            }
        }
    }

    private func map(_: Data, and response: HTTPURLResponse) -> SetMasterSharingService.Result {
        switch response.statusCode {
        case 401:
            return .unauthorized
        case 403:
            return .masterAlreadySet
        case 200:
            return nil
        default:
            return .invalidData
        }
    }
}
