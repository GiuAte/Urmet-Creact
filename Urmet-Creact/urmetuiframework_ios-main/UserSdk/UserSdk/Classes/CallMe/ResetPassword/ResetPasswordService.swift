//
//  ResetPasswordService.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 07/07/22.
//

import Foundation

public final class ResetPasswordService: IResetPasswordService {
    public enum Error: Swift.Error {
        case connectivity
        case invaliData
        case emailNotFound
    }

    private let OK = 200
    private let NOT_FOUND = 404
    private let servicePath = "/tool/multiapi/public/recovery/"

    private let baseURL: URL
    private let client: HTTPClient

    init(baseURL: URL, client: HTTPClient) {
        self.baseURL = baseURL
        self.client = client
    }

    private struct Request: Encodable {
        let email: String
    }

    public func resetPassword(forAccountWithEmail email: String, completion: @escaping Completion) {
        let url = baseURL.appendingPathComponent(servicePath)
        let headers = ["Content-Type": "application/json"]
        let request = Request(email: email)
        let body = try! JSONEncoder().encode(request)

        client.post(toURL: url, withHeaders: headers, andBody: body) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success((data, httpResponse)):
                completion(self.map(data, httpResponse))

            default:
                completion(ResetPasswordService.Error.connectivity)
            }
        }
    }

    private func map(_: Data, _ httpResponse: HTTPURLResponse) -> IResetPasswordService.Result {
        if httpResponse.statusCode == NOT_FOUND {
            return ResetPasswordService.Error.emailNotFound
        }
        guard httpResponse.statusCode == OK else {
            return ResetPasswordService.Error.invaliData
        }

        return nil
    }
}
