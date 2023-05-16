//
//  IUserChangePasswordService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 11/10/22.
//

import Foundation

public protocol IUserChangePasswordService {
    typealias UserChangePasswordResult = Swift.Result<Bool, Error>
    typealias UserChangePasswordCompletion = (UserChangePasswordResult) -> Void

    func change(newPassword: String, oldPassword: String, completion: @escaping UserChangePasswordCompletion)
}
