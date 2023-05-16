//
//  CloudAccountCreatorService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 17/06/22.
//

import Foundation

public final class CloudAccountCreatorService: ICloudAccountCreatorService {
    public enum Error: Swift.Error {
        case invalidEmail
        case invalidPassword
        case emailTaken
        case invalidResponse
        case missingStatement
        case invalidOrigin
        case connectivity
    }

    private let client: HTTPClient
    private let baseUrl: URL
    private let emailValidator: EmailValidator.Type
    private let passwordValidator: PasswordValidator.Type

    init(client: HTTPClient, baseUrl: URL, emailValidator: EmailValidator.Type, passwordValidator: PasswordValidator.Type) {
        self.client = client
        self.baseUrl = baseUrl
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
    }

    private struct Request: Encodable {
        let name: String
        let surname: String
        let username: String
        let email: String
        let userpass: String
        let prof_category: String
        let origin: String
        let country: String
        let language: String
        let stm_list: [GDPRStatementToUpload]
    }

    public func create(name: String,
                       surname: String,
                       email: String,
                       password: String,
                       origin: String,
                       country: String,
                       language: String,
                       statements: [GDPRStatementToUpload],
                       completion: @escaping Completion)
    {
        let url = URL(string: "\(baseUrl.absoluteString)/tool/multiapi/public/register/")!

        if !emailValidator.isEmailValid(email) {
            return completion(.failure(CloudAccountCreatorService.Error.invalidEmail))
        } else if !passwordValidator.isPasswordValid(password) {
            return completion(.failure(CloudAccountCreatorService.Error.invalidPassword))
        }

        let request = Request(
            name: name,
            surname: surname,
            username: email,
            email: email,
            userpass: password,
            prof_category: "private",
            origin: origin,
            country: country,
            language: language,
            stm_list: statements
        )

        let requestBody = try! JSONEncoder().encode(request)

        client.put(toURL: url, withHeaders: [:], andBody: requestBody) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success((data, httpResponse)):
                completion(self.map(data, and: httpResponse))

            default:
                completion(.failure(CloudAccountCreatorService.Error.connectivity))
            }
        }
    }

    private func map(_ data: Data, and response: HTTPURLResponse) -> CloudAccountCreatorService.Result {
        if response.statusCode == 400 {
            return .failure(CloudAccountCreatorService.Error.invalidPassword)
        }

        if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: String] {
            if jsonResponse!.contains(where: { $0.key == "reason" && $0.value == "username" }) {
                return .failure(CloudAccountCreatorService.Error.emailTaken)
            } else if jsonResponse!.contains(where: { $0.key == "missed_mandatory_stm" || $0.key == "missed_stm" }) {
                return .failure(CloudAccountCreatorService.Error.missingStatement)
            } else if jsonResponse!.contains(where: { $0.key == "gdpr retrive statements failed, check origin" }) {
                return .failure(CloudAccountCreatorService.Error.invalidOrigin)
            } else if jsonResponse!.contains(where: { $0.key == "tsupd" }) {
                return .success(true)
            }
        }

        return .failure(CloudAccountCreatorService.Error.invalidResponse)
    }
}
