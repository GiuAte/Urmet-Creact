//
//  UsernameCell.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 08/05/23.
//

import Foundation


class UsernameCell {
    var name: String?
    var lastName: String?
    
    required init(name: String? = nil, lastName: String? = nil) {
        self.name = name
        self.lastName = lastName
    }
}
