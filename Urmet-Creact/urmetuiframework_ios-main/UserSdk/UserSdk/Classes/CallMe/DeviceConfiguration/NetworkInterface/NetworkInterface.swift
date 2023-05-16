//
//  NetworkInterface.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 03/10/22.
//

import Foundation

public protocol NetworkInterface {
    func isWireless() -> Bool
    func wifiEncryption() -> String
    func wifiPassword() -> String
    func wifiSsid() -> String
    func switchOffWifiIntervals() -> [String]
    func switchOnWifiIntervals() -> [String]
}
