//
//  IUniqueSipAccount.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 15/11/22.
//

import Foundation

enum UniqueSipAccountGetError: Swift.Error {
    case accountNotFound
    case generic
}

enum UniqueSipAccountGenerateError: Swift.Error {
    case alreadyExists
    case generic
    case connectivity
    case invalidData
    case unauthorized
}

protocol IUniqueSipAccountService {
    typealias GenerateResult = Swift.Result<Account, UniqueSipAccountGenerateError>
    typealias GenerateCompletion = (GenerateResult) -> Void
    typealias GetResult = Swift.Result<Account, UniqueSipAccountGetError>
    typealias GetCompletion = (GetResult) -> Void

    func generate(forUsername username: String, andRealm realm: String, completion: @escaping GenerateCompletion)
    func get(completion: @escaping GetCompletion)
}
