//
//  WifiIntervalsConfiguration.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 19/10/22.
//

import Foundation

public struct WifiIntervalsConfiguration {
    var switchOffIntervals: [String]
    var switchOnIntervals: [String]

    public init(switchOffIntervals: [String], switchOnIntervals: [String]) {
        self.switchOffIntervals = switchOffIntervals
        self.switchOnIntervals = switchOnIntervals
    }
}
