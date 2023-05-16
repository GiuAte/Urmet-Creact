//
//  IAlarmsService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 23/12/22.
//

import Foundation

public protocol IAlarmsService {
    typealias Result = Swift.Result<[Alarm], Error>
    typealias Completion = (Result) -> Void

    func get(forPlace place: Place, completion: @escaping Completion)
    func update(forPlace place: Place, completion: @escaping Completion)
}
