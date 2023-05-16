//
//  NetworkInterfaceWireless.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 03/10/22.
//

import Foundation

public struct NetworkInterfaceWireless: NetworkInterface {
    private let encryption: String
    private let password: String
    private let ssid: String
    private let wifiIntervals: WifiIntervalsConfiguration

    public init(encryption: String, password: String, ssid: String, wifiIntervalsConfiguration: WifiIntervalsConfiguration) {
        self.encryption = encryption
        self.password = password
        self.ssid = ssid
        wifiIntervals = wifiIntervalsConfiguration
    }

    public func isWireless() -> Bool {
        return true
    }

    public func wifiEncryption() -> String {
        return encryption
    }

    public func wifiPassword() -> String {
        return password
    }

    public func wifiSsid() -> String {
        return ssid
    }

    public func switchOffWifiIntervals() -> [String] {
        return wifiIntervals.switchOffIntervals
    }

    public func switchOnWifiIntervals() -> [String] {
        return wifiIntervals.switchOnIntervals
    }
}
