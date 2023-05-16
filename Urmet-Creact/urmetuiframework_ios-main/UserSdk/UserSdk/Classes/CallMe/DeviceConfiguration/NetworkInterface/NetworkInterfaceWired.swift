//
//  NetworkInterfaceWired.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 03/10/22.
//

import Foundation

public struct NetworkInterfaceWired: NetworkInterface {
    public init() {}

    public func isWireless() -> Bool {
        return false
    }

    public func wifiEncryption() -> String {
        return ""
    }

    public func wifiPassword() -> String {
        return ""
    }

    public func wifiSsid() -> String {
        return ""
    }

    public func switchOffWifiIntervals() -> [String] {
        return []
    }

    public func switchOnWifiIntervals() -> [String] {
        return []
    }
}
