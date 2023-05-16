//
//  EmailValidator.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 21/07/22.
//

import Foundation

public protocol EmailValidator {
    static func isEmailValid(_ email: String) -> Bool
}
