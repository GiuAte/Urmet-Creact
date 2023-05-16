//
//  SipUriBuilder.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 13/10/22.
//

import Foundation

class SipUriBuilder {
    static func build(withUsername username: String, andRealm realm: String) -> String {
        return "sip:\(username)@\(realm)"
    }
}
