//
//  MissedCall.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 16/09/22.
//

import Foundation

public struct MissedCall: Hashable {
    public let caller: String
    public let hasSnapshot: Bool
    public let ts: UInt64
    let ipercomAttributes: IpercomMissedCallAttributes?
    let cfwAttributes: CfwMissedCallAttributes?
}

struct IpercomMissedCallAttributes: Hashable {
    let call_type: String
    let caller_code: String
}

struct CfwMissedCallAttributes: Hashable {
    let mac: String
}
