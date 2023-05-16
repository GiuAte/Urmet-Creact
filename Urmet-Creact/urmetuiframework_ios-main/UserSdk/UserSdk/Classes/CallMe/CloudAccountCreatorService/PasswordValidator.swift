//
//  PasswordValidator.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 21/07/22.
//

import Foundation

public protocol PasswordValidator {
    static func isPasswordValid(_ password: String) -> Bool
}
