//
//  Wifi.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 14/10/22.
//

import Foundation

public struct Wifi: Hashable {
    /// Wifi SSID
    public let ssid: String

    /// Wifi signal strength (in dB)
    public let power: Int

    /// Wifi encryption (WEP, WPA, ...)
    public let security: String

    public init(ssid: String, power: Int, security: String) {
        self.ssid = ssid
        self.power = power
        self.security = security
    }
}
