//
//  SipMessageTokenBuilder.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 13/10/22.
//

import Foundation

class SipMessageTokenBuilder {
    static func build(withTimestamp timestamp: UInt64, andChannelPassword password: String) -> String {
        return "\(timestamp)$\(password)".sha1
    }
}
