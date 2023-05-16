//
//  Configuration.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 30/09/22.
//

import Foundation

public struct Configuration {
    public let ipConfiguration: IpConfiguration
    public let name: String
    public let alarm: String
    public let timezone: String
    public let networkInterface: NetworkInterface
    public let sipConfiguration: SipConfiguration
    public let videoQuality: VideoQuality
    public let wifiList: [Wifi]

    public init(ipConfiguration: IpConfiguration,
                name: String,
                alarm: String,
                timezone: String,
                networkInterface: NetworkInterface,
                sipConfiguration: SipConfiguration,
                videoQuality: VideoQuality,
                wifiList: [Wifi] = [])
    {
        self.ipConfiguration = ipConfiguration
        self.name = name
        self.alarm = alarm
        self.timezone = timezone
        self.networkInterface = networkInterface
        self.sipConfiguration = sipConfiguration
        self.videoQuality = videoQuality
        self.wifiList = wifiList
    }
}
