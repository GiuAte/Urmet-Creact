//
//  ICreateSipAccountService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 18/10/22.
//

import Foundation

protocol ICreateSipAccountService {
    typealias CreateResult = Swift.Result<Bool, Error>
    typealias CreateCompletion = (CreateResult) -> Void

    func create(accountWithUsername username: String, andPassword password: String, forRealm realm: String, completion: @escaping CreateCompletion)
}
