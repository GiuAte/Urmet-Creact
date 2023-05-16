//
//  IGetDevicesSipService.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 13/09/22.
//

import Foundation

protocol IGetDevicesSipService {
    typealias Result = Swift.Result<[Device], Error>
    typealias Completion = (Result) -> Void

    func getDevices(for place: Place, andReplyTo responseUri: String, completion: @escaping Completion)
}
