//
//  IMissedCallsLoader.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 18/11/22.
//

import Foundation

protocol IMissedCallsLoader {
    typealias Result = Swift.Result<[MissedCall], Error>
    typealias Completion = (Result) -> Void

    func get(forPlace place: Place, completion: @escaping Completion)
    func update(forPlace place: Place, completion: @escaping Completion)
}
