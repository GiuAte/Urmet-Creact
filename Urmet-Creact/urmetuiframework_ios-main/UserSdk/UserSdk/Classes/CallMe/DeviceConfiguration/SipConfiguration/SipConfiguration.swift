//
//  SipConfiguration.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 12/10/22.
//

import Foundation

public struct SipConfiguration {
    public let username: String
    public let password: String
    public let server: String
    public let stun: String

    public init(username: String, password: String, server: String, stun: String) {
        self.username = username
        self.password = password
        self.server = server
        self.stun = stun
    }
}
