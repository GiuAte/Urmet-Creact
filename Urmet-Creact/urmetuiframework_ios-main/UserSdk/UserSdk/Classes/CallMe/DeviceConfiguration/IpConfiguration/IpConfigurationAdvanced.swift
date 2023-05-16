//
//  IpConfigurationAdvanced.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 10/10/22.
//

import Foundation

public struct IpConfigurationAdvanced: IpConfiguration {
    private let ip: String
    private let subnetMask: String
    private let defaultGateway: String
    private let dns: String

    public init(ip: String, subnetMask: String, defaultGateway: String, dns: String) {
        self.ip = ip
        self.subnetMask = subnetMask
        self.defaultGateway = defaultGateway
        self.dns = dns
    }

    public func isDhcpEnabled() -> Bool {
        return false
    }

    public func getIpAddress() -> String {
        return ip
    }

    public func getSubnetMask() -> String {
        return subnetMask
    }

    public func getDefaultGateway() -> String {
        return defaultGateway
    }

    public func getDns() -> String {
        return dns
    }
}
