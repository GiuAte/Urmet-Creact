//
//  IResetPassword.swift
//  CallMeSdk
//
//  Created by Silvio Fosso on 26/01/23.
//

import Foundation
public protocol IResetPassword: AnyObject {
    func success(value: Bool)
    func error(error: Error)
}
