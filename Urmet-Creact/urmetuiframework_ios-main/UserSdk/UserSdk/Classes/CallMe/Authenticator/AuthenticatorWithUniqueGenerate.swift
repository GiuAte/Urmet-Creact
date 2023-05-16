//
//  AuthenticatorWithUniqueGenerate.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 21/12/22.
//

import Foundation

public class AuthenticatorWithUniqueGenerate: IAuthenticator {
    public enum Error: Swift.Error {
        case invalidCredentials
        case connectivity
        case internalError
    }

    private var authenticatorService: IAuthenticator

    init(authenticatorService: IAuthenticator) {
        self.authenticatorService = authenticatorService
    }

    public func login(withEmail email: String, andPassword password: String, completion: @escaping Completion) {
        authenticatorService.login(withEmail: email, andPassword: password) { result in
            switch result {
            case let .success(success):
                completion(.success(success))
            case let .failure(error as Authenticator.Error):
                completion(.failure(self.map(error)))
            case .failure:
                completion(.failure(Error.internalError))
            }
        }
    }

    public func logout(completion: @escaping Completion) {
        authenticatorService.logout { result in
            completion(result)
        }
    }

    private func map(_ error: UniqueSipAccountGenerateError) -> Error {
        switch error {
        case .connectivity:
            return .connectivity
        default:
            return .internalError
        }
    }

    private func map(_ error: Authenticator.Error) -> Error {
        switch error {
        case .invalidCredentials:
            return .invalidCredentials
        case .connectivity:
            return .connectivity
        }
    }
}
