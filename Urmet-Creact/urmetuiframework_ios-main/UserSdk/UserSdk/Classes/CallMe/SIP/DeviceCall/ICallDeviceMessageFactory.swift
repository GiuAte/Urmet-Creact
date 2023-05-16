//
//  ICallDeviceMessageFactory.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 21/11/22.
//

import Foundation

protocol ICallDeviceMessageFactory {
    static func makeCallDeviceReqMessage(messageId: Int32,
                                         channelNumber: Int,
                                         channelPassword: String,
                                         responseUri: String,
                                         timestamp: UInt64,
                                         version: Int,
                                         topological_code: String,
                                         display_name: String,
                                         vds_types: String,
                                         uri_to_call: String,
                                         call_type: String) -> Data

    static func makeCancelCallReqMessage(messageId: Int32,
                                         channelNumber: Int,
                                         channelPassword: String,
                                         responseUri: String,
                                         timestamp: UInt64,
                                         version: Int,
                                         topological_code: String,
                                         display_name: String,
                                         vds_types: String,
                                         uri_to_call: String,
                                         call_type: String) -> Data
}
