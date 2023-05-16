//
//  Place+extractIncomingSIPUsername.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 04/10/22.
//

import Foundation

extension Place {
    static func extractSIPIncomingUsername(place: Place) -> String? {
        return place.accounts.filter { $0.direction == .incoming }.first?.username
    }
}
