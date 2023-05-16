//
//  OldCfwMissedCallsMessageFactory.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 27/09/22.
//

import Foundation

final class OldCfwMissedCallsMessageFactory: MissedCallMessageFactory {
    private static let type = "introduction_req"

    static func makeMessage(messageId: Int32, channelNumber: Int, channelPassword: String, responseUri: String, timestamp: UInt64, version: Int) -> Data {
        let token = SipMessageTokenBuilder.build(withTimestamp: timestamp, andChannelPassword: channelPassword)
        let body = SipRequestMessageBody(
            channel: channelNumber,
            id: messageId,
            response_uri: responseUri,
            token: token,
            ts: timestamp,
            type: type,
            version: version
        )

        return try! JSONEncoder().encode(body)
    }
}
