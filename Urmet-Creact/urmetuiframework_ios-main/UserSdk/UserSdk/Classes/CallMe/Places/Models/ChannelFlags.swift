//
//  ChannelFlags.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 05/07/22.
//

import Foundation

struct ChannelFlags: Decodable, Equatable {
    let uid: String
    let channel_number: String
    public let flags: UInt64
}
