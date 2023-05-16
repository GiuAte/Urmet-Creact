//
//  Account.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 23/06/22.
//

import Foundation

enum AccountDirection: String {
    case incoming, outgoing, bidirectional, instance
}

struct Account: Hashable {
    let username: String
    let password: String
    let realm: String
    let direction: AccountDirection
    let placeID: String
    let channelNumber: Int

    func getUri() -> String {
        "sip:\(username)@\(realm)"
    }
}
