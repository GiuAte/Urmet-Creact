//
//  MacToCredentials.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 03/11/22.
//

import Foundation

class MacToCredentials {
    static func getUsername(mac: String) -> String {
        let digitsString = mac.replacingOccurrences(of: ":", with: "")
        var username = ""

        digitsString.enumerated().forEach {
            if $0.offset > 0, $0.offset % 2 == 0 { username.append("_") }
            username.append($0.element)
        }
        return username
    }

    static func getPassword(mac: String) -> String {
        let digitsString = mac.replacingOccurrences(of: ":", with: "")
        var macAddress = ""

        digitsString.enumerated().forEach {
            if $0.offset > 0, $0.offset % 2 == 0 { macAddress.append(":") }
            macAddress.append($0.element)
        }
        return "Cf2" + "\(macAddress)CFWB".md5.prefix(9)
    }
}
