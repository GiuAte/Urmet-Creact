//
//  IIpercomCallDeviceSipService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 21/11/22.
//

import Foundation

protocol IIpercomCallDeviceSipService {
    typealias Result = Swift.Result<Bool, Error>
    typealias Completion = (Result) -> Void

    func call(device: Device, ofPlace place: Place, callBackUri: String, withDisplayName display_name: String, andReplyTo responseUri: String, completion: @escaping Completion)
    func cancelCall(device: Device, ofPlace place: Place, callBackUri: String, withDisplayName display_name: String, andReplyTo responseUri: String, completion: @escaping Completion)
}
