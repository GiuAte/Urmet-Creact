//
//  Login.swift
//  CallMeSdk
//
//  Created by Silvio Fosso on 26/01/23.
//

import Foundation
public class Login {
    private var authenticatorService: IAuthenticator?

    public weak var delegate: ILoginProtocol?

    public init() {
        authenticatorService = HttpHandler.shared.getSdk()?.getAuthenticator()
    }
}

public extension Login {
    func executeLogin(email: String, password: String) {
        authenticatorService?.login(withEmail: email, andPassword: password) { result in
            switch result {
            case let .success(value):
                self.delegate?.success(isLogged: value, session: HttpHandler.shared.httpClient)
            case let .failure(error):
                self.delegate?.error(error: error)
            }
        }
    }
}
