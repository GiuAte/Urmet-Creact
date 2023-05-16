//
//  User.swift
//  CallMe
//
//  Created by Luca Lancellotti on 02/08/22.
//

import Foundation

class User {
    var name: String
    var surname: String

    var fullName: String {
        return "\(name) \(surname)"
    }

    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
    }
}
