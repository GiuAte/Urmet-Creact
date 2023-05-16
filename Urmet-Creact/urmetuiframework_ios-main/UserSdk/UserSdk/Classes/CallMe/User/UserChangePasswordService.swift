//
//  UserChangePasswordService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 22/09/22.
//

import Foundation

public final class UserChangePasswordService: IUserChangePasswordService {
    public enum Error: Swift.Error {
        case invalidPassword
        case invalidOldPassword
        case connectivity
        case unauthorized
        case invalidData
    }

    private struct Request: Encodable {
        let oldpwd: String
        let newpwd: String
    }

    private let OK = 200
    private let NOT_AUTHORIZED = 401
    private let PRECONDITION_FAILED = 412

    private let validator: PasswordValidator.Type
    private let baseUrl: URL
    private let client: HTTPClient
    private let path = "/tool/multiapi/private/user/password"

    init(validator: PasswordValidator.Type, baseUrl: URL, client: HTTPClient) {
        self.validator = validator
        self.baseUrl = baseUrl
        self.client = client
    }

    public func change(newPassword: String, oldPassword: String, completion: @escaping UserChangePasswordCompletion) {
        if !validator.isPasswordValid(newPassword) || oldPassword.isEmpty {
            return completion(.failure(UserChangePasswordService.Error.invalidPassword))
        }

        let url = baseUrl.appendingPathComponent(path)
        let request = Request(oldpwd: oldPassword, newpwd: newPassword)
        let body = try! JSONEncoder().encode(request)

        client.post(toURL: url, withHeaders: [:], andBody: body) { result in
            switch result {
            case let .success((data, httpResponse)):
                completion(self.map(data: data, httpResponse: httpResponse))
            case .failure:
                completion(.failure(UserChangePasswordService.Error.connectivity))
            }
        }
    }

    private func map(data _: Data, httpResponse: HTTPURLResponse) -> UserChangePasswordResult {
        if httpResponse.statusCode == NOT_AUTHORIZED {
            return .failure(UserChangePasswordService.Error.unauthorized)
        } else if httpResponse.statusCode == PRECONDITION_FAILED {
            return .failure(UserChangePasswordService.Error.invalidOldPassword)
        } else if httpResponse.statusCode != OK {
            return .failure(UserChangePasswordService.Error.invalidData)
        }

        return .success(true)
    }
}
