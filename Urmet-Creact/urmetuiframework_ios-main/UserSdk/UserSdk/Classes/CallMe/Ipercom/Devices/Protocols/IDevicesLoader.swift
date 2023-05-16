//
//  IDevicesLoader.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 27/12/22.
//

import Foundation
public protocol IDevicesLoader {
    typealias Result = Swift.Result<[Device], Error>
    typealias Completion = (Result) -> Void

    func get(forPlace place: Place, completion: @escaping Completion)
    func update(forPlace place: Place, completion: @escaping Completion)
}
