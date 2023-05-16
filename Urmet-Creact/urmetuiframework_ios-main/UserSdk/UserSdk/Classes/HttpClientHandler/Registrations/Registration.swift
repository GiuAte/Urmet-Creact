//
//  Registration.swift
//  CallMeSdk
//
//  Created by Silvio Fosso on 26/01/23.
//

import Foundation
public class Registration {
    private var cloudAccountCreatorService: ICloudAccountCreatorService?

    public weak var delegate: IRegistration?

    public init() {
        cloudAccountCreatorService = HttpHandler.shared.getSdk()?.getCloudAccountCreatorService()
    }

    public func register(name: String, surname: String, email: String, password: String, country: String, language: String, statements: [GDPRModel]) {
        executeCreateAccount(name: name, surname: surname, email: email, password: password, country: country, language: language, statements: statements)
    }
}

extension Registration {
    private
    func executeCreateAccount(name: String,
                              surname: String,
                              email: String,
                              password: String,
                              origin: String = HttpHandler.shared.origin,
                              country: String,
                              language: String,
                              statements: [GDPRModel])
    {
        // In a usual workflow, the user must accept all the mandatory gdpr statements, before creating a new account.
        // For simpleness, we assume all the statements are accepted

        // Don't do the following line in production code!
        let statementsToUpload = statements.map { GDPRStatementToUpload(id: $0.id, selected: $0.status) }

        cloudAccountCreatorService?.create(name: name,
                                           surname: surname,
                                           email: email,
                                           password: password,
                                           origin: origin,
                                           country: country,
                                           language: language,
                                           statements: statementsToUpload) { result in
            switch result {
            case let .success(value):
                self.delegate?.success(isSucceded: value)
            case let .failure(error):
                self.delegate?.error(error: error)
            }
        }
    }
}
