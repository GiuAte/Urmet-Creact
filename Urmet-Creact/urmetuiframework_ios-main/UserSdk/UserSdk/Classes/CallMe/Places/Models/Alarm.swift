//
//  Alarm.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 19/09/22.
//

import Foundation

public struct Alarm: Hashable {
    public let sender: String?
    public let state: AlarmState
    public let ts: UInt64
    public let type: AlarmType
    let ipercomAttributes: IpercomAlarmAttributes?
    let cfwAttributes: CfwAlarmAttributes?
}

struct IpercomAlarmAttributes: Hashable {
    let topological_code: String
    let vds_types: String
}

struct CfwAlarmAttributes: Hashable {
    let mac: String
}

public enum AlarmState: String, Decodable, Hashable {
    case Active = "active"
    case Reset = "reset"
    case Unknown = "unknown"
}

public enum AlarmType: String, Decodable, Hashable {
    case Panic = "panic_alarm"
    case Fire = "fire_alarm"
    case Gas = "gas_alarm"
    case Flooding = "flooding"
    case Intrusion = "intrusion"
    case Coercion = "coercion"
    case Tamper = "tamper"
    case Help = "help"
    case SystemFailure = "system_failure"
    case DoorForced = "door_forced"
    case DoorLeftOpen = "door_left_open"
    case Burglar = "burglar"
    case LowBattery = "low_battery"
    case Generic = "generic_alarm"
    case Unknown = "unknown"
}
