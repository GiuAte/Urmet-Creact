//
//  DeviceConfigurationPayload.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 19/10/22.
//

import Foundation

struct DeviceConfigurationPayload: Codable {
    let action: UInt8
    let dhcp: Bool
    let dns: String
    let eth: Bool
    let gateway: String
    let ip: String
    let login: String
    let mask: String
    let name: String
    let password: String
    let sipserver: String
    let stunserver: String
    let videoquality: Int
    let wifissid: String
    let wifikey: String
    let wifipassword: String
    let wifissidlist: [String]
    let wifikeylist: [String]
    let wifiqualitylist: [Int]
    let nowifibeginlist: [String]
    let nowifiendlist: [String]
    let timezone: String
    let alarm: String
    let profileLowResolution: String
    let profileLowFrameRate: Float
    let profileLowKbps: Int
    let profileMediumResolution: String
    let profileMediumFrameRate: Float
    let profileMediumKbps: Int
    let profileHighResolution: String
    let profileHighFrameRate: Float
    let profileHighKbps: Int

    init(action: UInt8,
         dhcp: Bool,
         dns: String,
         eth: Bool,
         gateway: String,
         ip: String,
         login: String,
         mask: String,
         name: String,
         password: String,
         sipserver: String,
         stunserver: String,
         videoquality: Int,
         wifissid: String,
         wifikey: String,
         wifipassword: String,
         wifissidlist: [String],
         wifikeylist: [String],
         wifiqualitylist: [Int],
         nowifibeginlist: [String],
         nowifiendlist: [String],
         timezone: String,
         alarm: String,
         profileLowResolution: String,
         profileLowFrameRate: Float,
         profileLowKbps: Int,
         profileMediumResolution: String,
         profileMediumFrameRate: Float,
         profileMediumKbps: Int,
         profileHighResolution: String,
         profileHighFrameRate: Float,
         profileHighKbps: Int)
    {
        self.action = action
        self.dhcp = dhcp
        self.dns = dns
        self.eth = eth
        self.gateway = gateway
        self.ip = ip
        self.login = login
        self.mask = mask
        self.name = name
        self.password = password
        self.sipserver = sipserver
        self.stunserver = stunserver
        self.videoquality = videoquality
        self.wifissid = wifissid
        self.wifikey = wifikey
        self.wifipassword = wifipassword
        self.wifissidlist = wifissidlist
        self.wifikeylist = wifikeylist
        self.wifiqualitylist = wifiqualitylist
        self.nowifibeginlist = nowifibeginlist
        self.nowifiendlist = nowifiendlist
        self.timezone = timezone
        self.alarm = alarm
        self.profileLowResolution = profileLowResolution
        self.profileLowFrameRate = profileLowFrameRate
        self.profileLowKbps = profileLowKbps
        self.profileMediumResolution = profileMediumResolution
        self.profileMediumFrameRate = profileMediumFrameRate
        self.profileMediumKbps = profileMediumKbps
        self.profileHighResolution = profileHighResolution
        self.profileHighFrameRate = profileHighFrameRate
        self.profileHighKbps = profileHighKbps
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        action = try container.decode(UInt8.self, forKey: .action)
        dhcp = try container.decode(Bool.self, forKey: .dhcp)
        dns = try container.decode(String.self, forKey: .dns)
        eth = try container.decode(Bool.self, forKey: .eth)
        gateway = try container.decode(String.self, forKey: .gateway)
        ip = try container.decode(String.self, forKey: .ip)
        login = try container.decode(String.self, forKey: .login)
        mask = try container.decode(String.self, forKey: .mask)
        name = try container.decode(String.self, forKey: .name)
        password = try container.decode(String.self, forKey: .password)
        sipserver = try container.decode(String.self, forKey: .sipserver)
        stunserver = try container.decode(String.self, forKey: .stunserver)
        videoquality = try container.decode(Int.self, forKey: .videoquality)
        wifissid = try container.decode(String.self, forKey: .wifissid)
        wifikey = try container.decode(String.self, forKey: .wifikey)
        wifipassword = try container.decode(String.self, forKey: .wifipassword)
        wifissidlist = try container.decode([String].self, forKey: .wifissidlist)
        wifikeylist = try container.decode([String].self, forKey: .wifikeylist)
        if let wifiqualitylist = try? container.decode([Int].self, forKey: .wifiqualitylist) {
            self.wifiqualitylist = wifiqualitylist
        } else if let wifiqualitylistStr = try? container.decode([String].self, forKey: .wifiqualitylist),
                  wifiqualitylistStr.count == wifiqualitylistStr.compactMap({ Int($0) }).count
        {
            wifiqualitylist = wifiqualitylistStr.compactMap { Int($0) }
        } else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Key: wifiqualitylist - Invalid Value")
            throw DecodingError.typeMismatch(DeviceConfigurationPayload.self, context)
        }
        nowifibeginlist = try container.decode([String].self, forKey: .nowifibeginlist)
        nowifiendlist = try container.decode([String].self, forKey: .nowifiendlist)
        timezone = try container.decode(String.self, forKey: .timezone)
        alarm = try container.decode(String.self, forKey: .alarm)
        profileLowResolution = try container.decode(String.self, forKey: .profileLowResolution)
        profileLowFrameRate = try container.decode(Float.self, forKey: .profileLowFrameRate)
        profileLowKbps = try container.decode(Int.self, forKey: .profileLowKbps)
        profileMediumResolution = try container.decode(String.self, forKey: .profileMediumResolution)
        profileMediumFrameRate = try container.decode(Float.self, forKey: .profileMediumFrameRate)
        profileMediumKbps = try container.decode(Int.self, forKey: .profileMediumKbps)
        profileHighResolution = try container.decode(String.self, forKey: .profileHighResolution)
        profileHighFrameRate = try container.decode(Float.self, forKey: .profileHighFrameRate)
        profileHighKbps = try container.decode(Int.self, forKey: .profileHighKbps)
    }

    enum CodingKeys: CodingKey {
        case action
        case dhcp
        case dns
        case eth
        case gateway
        case ip
        case login
        case mask
        case name
        case password
        case sipserver
        case stunserver
        case videoquality
        case wifissid
        case wifikey
        case wifipassword
        case wifissidlist
        case wifikeylist
        case wifiqualitylist
        case nowifibeginlist
        case nowifiendlist
        case timezone
        case alarm
        case profileLowResolution
        case profileLowFrameRate
        case profileLowKbps
        case profileMediumResolution
        case profileMediumFrameRate
        case profileMediumKbps
        case profileHighResolution
        case profileHighFrameRate
        case profileHighKbps
        case wirelessDoorOpen
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action, forKey: .action)
        try container.encode(dhcp, forKey: .dhcp)
        try container.encode(dns, forKey: .dns)
        try container.encode(eth, forKey: .eth)
        try container.encode(gateway, forKey: .gateway)
        try container.encode(ip, forKey: .ip)
        try container.encode(login, forKey: .login)
        try container.encode(mask, forKey: .mask)
        try container.encode(name, forKey: .name)
        try container.encode(password, forKey: .password)
        try container.encode(sipserver, forKey: .sipserver)
        try container.encode(stunserver, forKey: .stunserver)
        try container.encode(videoquality, forKey: .videoquality)
        try container.encode(wifissid, forKey: .wifissid)
        try container.encode(wifikey, forKey: .wifikey)
        try container.encode(wifipassword, forKey: .wifipassword)
        try container.encode(nowifibeginlist, forKey: .nowifibeginlist)
        try container.encode(nowifiendlist, forKey: .nowifiendlist)
        try container.encode(timezone, forKey: .timezone)
        try container.encode(alarm, forKey: .alarm)
        try container.encode(profileLowResolution, forKey: .profileLowResolution)
        try container.encode(profileLowFrameRate, forKey: .profileLowFrameRate)
        try container.encode(profileLowKbps, forKey: .profileLowKbps)
        try container.encode(profileMediumResolution, forKey: .profileMediumResolution)
        try container.encode(profileMediumFrameRate, forKey: .profileMediumFrameRate)
        try container.encode(profileMediumKbps, forKey: .profileMediumKbps)
        try container.encode(profileHighResolution, forKey: .profileHighResolution)
        try container.encode(profileHighFrameRate, forKey: .profileHighFrameRate)
        try container.encode(profileHighKbps, forKey: .profileHighKbps)
    }
}

// Workaround: il firmware sul /58A accetta la configurazione ma poi si reboota, se non viene inviato il valore con la sua parte decimale (anche se zero)
// Swift, pur essendo un Float, se la sua parte decimale è zero, durante l'encoding "castra" il valore togliendo la parte decimale
// per questo bisogna eseguire una replacingOccurrences a mano...

extension JSONEncoder {
    func encode(deviceConfigurationPayload: DeviceConfigurationPayload) throws -> Data {
        let data = try! encode(deviceConfigurationPayload)
        var jsonString = String(data: data, encoding: .utf8)!
        let lowFrameRate = deviceConfigurationPayload.profileLowFrameRate
        let mediumFrameRate = deviceConfigurationPayload.profileMediumFrameRate
        let highFrameRate = deviceConfigurationPayload.profileHighFrameRate
        jsonString = jsonString.replacingOccurrences(of: "\"profileLowFrameRate\":\(String(format: "%.0f", lowFrameRate))",
                                                     with: "\"profileLowFrameRate\":\(String(format: "%.1f", lowFrameRate))")
        jsonString = jsonString.replacingOccurrences(of: "\"profileMediumFrameRate\":\(String(format: "%.0f", mediumFrameRate))",
                                                     with: "\"profileMediumFrameRate\":\(String(format: "%.1f", mediumFrameRate))")
        jsonString = jsonString.replacingOccurrences(of: "\"profileHighFrameRate\":\(String(format: "%.0f", highFrameRate))",
                                                     with: "\"profileHighFrameRate\":\(String(format: "%.1f", highFrameRate))")
        return jsonString.data(using: .utf8)!
    }
}
