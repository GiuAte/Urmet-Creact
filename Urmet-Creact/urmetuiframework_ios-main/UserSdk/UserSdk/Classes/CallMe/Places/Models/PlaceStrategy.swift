//
//  PlaceStrategy.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 10/10/22.
//

import Foundation

enum PlaceStrategy: String {
    // Missed calls
    case IpercomMissedCalls
    case VOG5MissedCalls
    case CFWMissedCalls
    case OldCFWMissedCalls

    // Alarms
    case IpercomAlarms
    case VOG5Alarms
    case CFWAlarms
    case OldCFWAlarms

    // Devices
    case IpercomDevices
    case VOG5Devices
    case CFWDevices
    case OldCFWDevices
}
