//
//  IMissedCallsService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 20/12/22.
//

import Foundation

public protocol IMissedCallsService {
    typealias Result = Swift.Result<[MissedCall], Error>
    typealias Completion = (Result) -> Void

    func get(forPlace place: Place, completion: @escaping Completion)
    func update(forPlace place: Place, completion: @escaping Completion)
}
