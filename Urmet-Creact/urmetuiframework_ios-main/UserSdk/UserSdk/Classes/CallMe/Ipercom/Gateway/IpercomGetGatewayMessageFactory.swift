//
//  IpercomGetGatewayMessageFactory.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 08/09/22.
//

import Foundation

final class IpercomGetGatewayMessageFactory: GatewayMessageFactory {
    private static let type = "get_gateway_sip_address_req"

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
