//
//  DeviceStatus.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 05/07/22.
//

import Foundation

struct DeviceStatus: Decodable, Hashable {
    let device_status: String
    let installation_name: String
    let has_owner: Bool
}
