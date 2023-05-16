//
//  IGetAlarmsSipService.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 19/09/22.
//

import Foundation

protocol IGetAlarmsSipService {
    typealias Result = Swift.Result<[Alarm], Error>
    typealias Completion = (Result) -> Void

    func getAlarms(for place: Place, andReplyTo responseUri: String, completion: @escaping Completion)
}
