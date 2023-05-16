//
//  CalleeInfo.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 16/11/22.
//

import Foundation

struct CalleeInfo: Equatable {
    let device: Device
    let place: Place

    static func == (lhs: CalleeInfo, rhs: CalleeInfo) -> Bool {
        return lhs.place.id == rhs.place.id &&
            lhs.device == rhs.device
    }
}
