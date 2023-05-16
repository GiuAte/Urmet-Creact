//
//  Validator.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 16/06/22.
//

import Foundation

public class Validator {
    private init() {}
}

extension Validator: EmailValidator {
    public static func isEmailValid(_ email: String) -> Bool {
        let pattern = "^([a-zA-Z0-9_\\-.]+)@([a-zA-Z0-9_\\-]+)(\\.([a-zA-Z]{2,5}))+$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: email.count)

        return !regex.matches(in: email, options: [], range: range).isEmpty
    }
}

extension Validator: PasswordValidator {
    public static func isPasswordValid(_ password: String) -> Bool {
        let MinPasswordLen = 6
        let MaxPasswordLen = 20

        guard password.count > MinPasswordLen, password.count < MaxPasswordLen else { return false }

        let pattern = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[$&+,:;=?@#|'<>.^*()%!-]).)"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: password.count)

        return !regex.matches(in: password, options: [], range: range).isEmpty
    }
}
