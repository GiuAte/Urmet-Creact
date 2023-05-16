//
//  Logout.swift
//  CallMeSdk
//
//  Created by Silvio Fosso on 27/01/23.
//

import Foundation
public class Logout {
    private var authenticatorService: IAuthenticator?

    public weak var delegate: ILogout?

    public init() {
        authenticatorService = HttpHandler.shared.getSdk()?.getAuthenticator()
    }

    public func doLogout() {
        executeLogout()
    }
}

extension Logout {
    private func executeLogout() {
        authenticatorService?.logout { result in

            switch result {
            case let .success(value):
                self.delegate?.success(value: value)
            case let .failure(error):
                self.delegate?.error(value: error)
            }
        }
    }
}
