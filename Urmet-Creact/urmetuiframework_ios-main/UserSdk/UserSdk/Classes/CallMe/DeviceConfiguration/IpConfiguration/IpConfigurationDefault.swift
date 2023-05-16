//
//  IpConfigurationDefault.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 03/10/22.
//

import Foundation

public struct IpConfigurationDefault: IpConfiguration {
    public init() {}

    public func isDhcpEnabled() -> Bool {
        return true
    }

    public func getIpAddress() -> String {
        return ""
    }

    public func getSubnetMask() -> String {
        return ""
    }

    public func getDefaultGateway() -> String {
        return ""
    }

    public func getDns() -> String {
        return ""
    }
}
