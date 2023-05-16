//
//  ICamerasLoader.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/12/22.
//

import Foundation

protocol ICamerasLoader {
    typealias Result = Swift.Result<[Camera], Error>
    typealias Completion = (Result) -> Void

    func get(forPlace place: Place, completion: @escaping Completion)
    func update(forPlace place: Place, completion: @escaping Completion)
}
