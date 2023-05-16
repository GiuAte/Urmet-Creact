//
//  Device.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 13/09/22.
//

import Foundation

public class Devices: Equatable {
    public static func == (lhs: Devices, rhs: Devices) -> Bool {
        return lhs.type == rhs.type &&
            lhs.ipercomAttributes == rhs.ipercomAttributes &&
            lhs.name == rhs.name
    }

    let name: String
    let type: DeviceType
    let ipercomAttributes: IpercomDeviceAttributes

    init(name: String, type: DeviceType, ipercomAttributes: IpercomDeviceAttributes) {
        self.name = name
        self.type = type
        self.ipercomAttributes = ipercomAttributes
    }
}

struct IpercomDeviceAttributes: Equatable {
    let topological_code: String
    let vds_types: String
}

enum DeviceType: String, Decodable, Hashable, CaseIterable {
    case Unknown = "unknown"
    case Intercom = "intercom"
    case Avatar = "intercom_avatar"
    case Camera = "calling_station"
}

extension DeviceType {
    var isContact: Bool {
        switch self {
        case .Intercom, .Avatar:
            return true
        default:
            return false
        }
    }

    var isCamera: Bool {
        switch self {
        case .Camera:
            return true
        default:
            return false
        }
    }
}
