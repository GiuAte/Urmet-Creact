//
//  CallDeviceMessageFactory.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 21/11/22.
//

import Foundation

class CallDeviceMessageFactory: ICallDeviceMessageFactory {
    static func makeCallDeviceReqMessage(messageId: Int32, channelNumber: Int, channelPassword: String, responseUri: String, timestamp: UInt64, version: Int, topological_code: String, display_name: String, vds_types: String, uri_to_call: String, call_type: String) -> Data {
        let type = "call_device_req"
        let token = SipMessageTokenBuilder.build(withTimestamp: timestamp, andChannelPassword: channelPassword)
        let body = CallDeviceMessageBody(channel: channelNumber,
                                         id: messageId,
                                         response_uri: responseUri,
                                         token: token,
                                         ts: timestamp,
                                         type: type,
                                         version: version,
                                         topological_code: topological_code,
                                         display_name: display_name,
                                         vds_types: vds_types,
                                         uri_to_call: uri_to_call,
                                         call_type: call_type)

        return try! JSONEncoder().encode(body)
    }

    static func makeCancelCallReqMessage(messageId: Int32, channelNumber: Int, channelPassword: String, responseUri: String, timestamp: UInt64, version: Int, topological_code: String, display_name: String, vds_types: String, uri_to_call: String, call_type: String) -> Data {
        let type = "cancel_call_req"
        let token = SipMessageTokenBuilder.build(withTimestamp: timestamp, andChannelPassword: channelPassword)
        let body = CallDeviceMessageBody(channel: channelNumber,
                                         id: messageId,
                                         response_uri: responseUri,
                                         token: token,
                                         ts: timestamp,
                                         type: type,
                                         version: version,
                                         topological_code: topological_code,
                                         display_name: display_name,
                                         vds_types: vds_types,
                                         uri_to_call: uri_to_call,
                                         call_type: call_type)

        return try! JSONEncoder().encode(body)
    }
}
