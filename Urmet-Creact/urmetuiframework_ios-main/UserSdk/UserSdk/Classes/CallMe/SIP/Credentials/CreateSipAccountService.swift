//
//  CreateSipAccountService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 17/10/22.
//

import Foundation

final class CreateSipAccountService: ICreateSipAccountService {
    public enum Error: Swift.Error {
        case connectivity
        case unauthorized
        case invalidData
    }

    private let client: HTTPClient
    private let baseURL: URL

    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }

    private lazy var requestUrl: URL = baseURL
        .appendingPathComponent("/tool/callmeapi/private/create_sip_account_no_mail_confirm/")

    func create(accountWithUsername username: String, andPassword password: String, forRealm realm: String, completion: @escaping CreateCompletion) {
        let requestUrl = requestUrl
            .appendingPathComponent(username)
            .appendingPathComponent(realm)
            .appendingPathComponent(password)

        client.post(toURL: requestUrl, withHeaders: [:], andBody: Data()) { [weak self] result in
            guard let self else { return }

            switch result {
            case .failure:
                completion(.failure(CreateSipAccountService.Error.connectivity))

            case let .success((data, httpResponse)):
                completion(self.map(data, httpResponse))
            }
        }
    }

    private func map(_: Data, _ httpResponse: HTTPURLResponse) -> CreateResult {
        if httpResponse.statusCode == 401 {
            return .failure(CreateSipAccountService.Error.unauthorized)
        } else if httpResponse.statusCode != 200 {
            return .failure(CreateSipAccountService.Error.invalidData)
        }

        return .success(true)
    }
}
