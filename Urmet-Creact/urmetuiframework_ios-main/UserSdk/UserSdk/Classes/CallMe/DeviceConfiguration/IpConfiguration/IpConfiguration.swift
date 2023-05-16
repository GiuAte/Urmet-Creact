//
//  IpConfiguration.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 03/10/22.
//

import Foundation

public protocol IpConfiguration {
    func isDhcpEnabled() -> Bool
    func getIpAddress() -> String
    func getSubnetMask() -> String
    func getDefaultGateway() -> String
    func getDns() -> String
}
