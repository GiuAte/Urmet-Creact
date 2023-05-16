//
//  IResetPasswordService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 11/10/22.
//

import Foundation

public protocol IResetPasswordService {
    typealias Result = Error?
    typealias Completion = (Result) -> Void

    func resetPassword(forAccountWithEmail email: String, completion: @escaping Completion)
}
