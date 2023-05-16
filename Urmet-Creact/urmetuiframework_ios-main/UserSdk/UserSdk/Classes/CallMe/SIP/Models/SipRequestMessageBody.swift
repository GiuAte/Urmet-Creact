//
//  SipRequestMessageBody.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 13/10/22.
//

import Foundation

class SipRequestMessageBody: Encodable {
    let channel: Int
    let id: Int32
    let response_uri: String
    let token: String
    let ts: UInt64
    let type: String
    let version: Int

    init(channel: Int, id: Int32, response_uri: String, token: String, ts: UInt64, type: String, version: Int) {
        self.channel = channel
        self.id = id
        self.response_uri = response_uri
        self.token = token
        self.ts = ts
        self.type = type
        self.version = version
    }
}
