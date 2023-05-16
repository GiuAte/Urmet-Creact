//
//  IpercomGetMissedCallMessageFactory.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 16/09/22.
//

import Foundation

final class GetMissedCallsMessageFactory: MissedCallMessageFactory {
    private static let type = "get_missed_calls_req"

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
