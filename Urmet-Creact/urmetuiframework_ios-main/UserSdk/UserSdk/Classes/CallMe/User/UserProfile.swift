//
//  UserProfile.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 21/07/22.
//

import Foundation

public struct UserProfile {
    public let email: String
    public let name: String
    public let surname: String
    public let pendingDeletion: Bool
    public let currentSipId: String

    public init(email: String, name: String, surname: String, pendingDeletion: String?, currentSipId: String) {
        self.email = email
        self.name = name
        self.surname = surname
        self.pendingDeletion = pendingDeletion == "1" ? true : false
        self.currentSipId = currentSipId
    }
}
