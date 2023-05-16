//
//  CallIdentifier.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 08/11/22.
//

import Foundation

struct CallIdentifier: Equatable {
    private(set) var callControllerId: UUID?
    var remoteUri: String?

    static func == (lhs: CallIdentifier, rhs: CallIdentifier) -> Bool {
        if let lhsSipUri = lhs.remoteUri,
           let rhsSipUri = rhs.remoteUri,
           lhsSipUri == rhsSipUri
        {
            return true
        }

        if let lhsCallControllerId = lhs.callControllerId,
           let rhsCallControllerId = rhs.callControllerId,
           lhsCallControllerId == rhsCallControllerId
        {
            return true
        }

        return false
    }
}
