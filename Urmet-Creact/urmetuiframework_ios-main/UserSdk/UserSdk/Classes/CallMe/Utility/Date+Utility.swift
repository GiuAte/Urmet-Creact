//
//  Date+Utility.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 14/09/22.
//

import Foundation

extension Date {
    var timestamp: UInt64 {
        return UInt64(timeIntervalSince1970)
    }
}
