//
//  MessageFactory.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 12/10/22.
//

import Foundation

protocol MessageFactory {
    static func makeMessage(messageId: Int32, channelNumber: Int, channelPassword: String, responseUri: String, timestamp: UInt64, version: Int) -> Data
}
