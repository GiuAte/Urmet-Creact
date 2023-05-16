//
//  ICloudAccountCreatorService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 11/10/22.
//

import Foundation

public protocol ICloudAccountCreatorService {
    typealias Result = Swift.Result<Bool, Error>
    typealias Completion = (Result) -> Void

    func create(name: String, surname: String, email: String, password: String, origin: String, country: String, language: String, statements: [GDPRStatementToUpload], completion: @escaping Completion)
}
