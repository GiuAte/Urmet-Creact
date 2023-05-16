//
//  IAuthenticator.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 17/06/22.
//

import Foundation

public protocol IAuthenticator {
    typealias Result = Swift.Result<Bool, Error>
    typealias Completion = (Result) -> Void

    func login(withEmail email: String, andPassword password: String, completion: @escaping Completion)
    func logout(completion: @escaping Completion)
}
