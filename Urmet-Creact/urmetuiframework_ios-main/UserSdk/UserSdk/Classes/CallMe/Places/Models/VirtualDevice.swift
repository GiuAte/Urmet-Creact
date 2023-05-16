//
//  VirtualDevice.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 04/07/22.
//

import Foundation

struct VirtualDevice: Decodable, Hashable {
    let device_id: String

    public var id: String { return device_id }
}
