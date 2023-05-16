//
//  CallDeviceMessageBody.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 21/11/22.
//

import Foundation

class CallDeviceMessageBody: SipRequestMessageBody {
    let topological_code: String
    let display_name: String
    let vds_types: String
    let uri_to_call: String
    let call_type: String

    init(channel: Int, id: Int32, response_uri: String, token: String, ts: UInt64, type: String, version: Int, topological_code: String, display_name: String, vds_types: String, uri_to_call: String, call_type: String) {
        self.topological_code = topological_code
        self.display_name = display_name
        self.vds_types = vds_types
        self.uri_to_call = uri_to_call
        self.call_type = call_type
        super.init(channel: channel, id: id, response_uri: response_uri, token: token, ts: ts, type: type, version: version)
    }

    enum CodingKeys: String, CodingKey {
        case topological_code
        case display_name
        case vds_types
        case uri_to_call
        case call_type
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(topological_code, forKey: .topological_code)
        try container.encode(display_name, forKey: .display_name)
        try container.encode(vds_types, forKey: .vds_types)
        try container.encode(uri_to_call, forKey: .uri_to_call)
        try container.encode(call_type, forKey: .call_type)
    }
}
