//
//  Authenticator.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 17/06/22.
//

import Foundation

public final class Authenticator: IAuthenticator {
    private let client: HTTPClient
    private let baseUrl: URL

    public enum Error: Swift.Error {
        case invalidCredentials
        case connectivity
    }

    init(client: HTTPClient, baseUrl: URL) {
        self.client = client
        self.baseUrl = baseUrl
    }

    public func login(withEmail email: String, andPassword password: String, completion: @escaping Completion) {
        let url = baseUrl.appendingPathComponent("/tool/index.php")
        let body = "httpd_username=\(email)&httpd_password=\(password)".data(using: .utf8)!
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]

        client.post(toURL: url, withHeaders: headers, andBody: body) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success((data, response)):
                completion(self.map(data, and: response))

            default:
                completion(.failure(Error.connectivity))
            }
        }
    }

    public func logout(completion: @escaping Completion) {
        let url = baseUrl.appendingPathComponent("/tool/logout.php")

        client.post(toURL: url, withHeaders: [:], andBody: Data()) { [weak self] result in
            guard let _ = self else { return }

            switch result {
            case .success:

                // MARK: non mi servirà al prossimo aggiornamento

                HttpHandler.shared.resetHTTPClientSession()
                completion(.success(true))

            default:
                completion(.failure(Error.connectivity))
            }
        }
    }

    private func map(_: Data, and response: HTTPURLResponse) -> Authenticator.Result {
        if response.statusCode == 401 {
            return .failure(Error.invalidCredentials)
        } else if response.statusCode != 200 {
            return .failure(Error.connectivity)
        }

        return .success(true)
    }
}
