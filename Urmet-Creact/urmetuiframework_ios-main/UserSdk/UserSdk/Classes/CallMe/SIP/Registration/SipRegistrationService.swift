//
//  SipRegistrationService.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 01/09/22.
//

import Foundation

final class SipRegistrationService {
    typealias Result = Error?
    typealias Completion = (Result) -> Void

    enum Error: Swift.Error {
        case sipServiceNotAvailable
        case registrationFailed
    }

    private let client: RegistrationSipClient

    init(client: RegistrationSipClient) {
        self.client = client
    }

    func register(_ account: Account, withParams params: RegistrationParams, completion: @escaping Completion) {
        client.unregister(account) { [weak self] _ in
            guard let self = self else { return }

            self.client.register(account, withParams: params) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .failure:
                    completion(.sipServiceNotAvailable)

                case let .success(state):
                    completion(self.map(state))
                }
            }
        }
    }

    private func map(_ state: SipRegistrationState) -> SipRegistrationService.Result {
        switch state {
        case .Ok:
            return nil
        case .Failed:
            return .registrationFailed
        }
    }
}
