//
//  GDPR.swift
//  PlugUI
//
//  Created by Silvio Fosso on 18/01/23.
//

import Foundation
import UIKit
public class GDPR {
    private var gdprService: IGDPRService?
    private var userProfileService: IUserProfileService?

    private var models: [GDPRModel] = []

    public weak var delegate: IGDPRProtocol?

    public init() {
        gdprService = HttpHandler.shared.getSdk()?.getGdprService()
        userProfileService = HttpHandler.shared.getSdk()?.getUserProfileService()
    }

    public func getGDPR() {
        getGDPRStatements()
    }

    public func getGDPRUserLogged() {
        executeGetGDPRStatements()
    }
}

extension GDPR {
    private func getGDPRStatements() {
        gdprService?.getStatements { gdprResult in
            switch gdprResult {
            case let .success(statements):

                self.models = self.map(statements: statements)
                self.delegate?.success(model: self.models)
            case let .failure(error):
                self.delegate?.error(error: error)
            }
        }
    }

    private func executeGetGDPRStatements() {
        gdprService?.getStatements { gdprResult in
            switch gdprResult {
            case let .success(statements):
                self.executeGetUserGDPRStatus(statements: statements)
            case let .failure(error):
                self.delegate?.error(error: error)
            }
        }
    }

    private func executeGetUserGDPRStatus(statements: [GDPRStatement]) {
        userProfileService?.getUserGDPRStatus { result in
            switch result {
            case let .success(statuses):
                self.models = self.map(statements: statements)
                self.map(statuses: statuses)
                self.delegate?.success(model: self.models)
            case let .failure(error):
                self.delegate?.error(error: error)
            }
        }
    }

    private func map(statements: [GDPRStatement]) -> [GDPRModel] {
        let language = GDPRLanguage(language: Language.language)
        return statements.map { GDPRModel(id: $0.id,
                                          title: $0.getTitle(language),
                                          content: $0.getContent(language),
                                          url: $0.getUrl(language),
                                          mandatory: $0.mandatory.description,
                                          status: .noChoice)
        }
    }

    private func map(statuses: [GDPRStatementStatus]) {
        statuses.forEach { status in
            for (idx, model) in models.enumerated() {
                if model.id == status.id {
                    models[idx].status = status.status
                }
            }
        }
    }
}
