//
//  SipMessage.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 08/11/22.
//

import Foundation

struct SipMessage {
    let eventType: CMEventType
    let callIdentifier: CallIdentifier
    let localUri: String
}
