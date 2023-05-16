//
//  PlaceLoader.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 21/06/22.
//

import Foundation

protocol PlaceLoader {
    typealias LoadResult = Swift.Result<[Place], Error>
    typealias Completion = (LoadResult) -> Void

    func get(completion: @escaping Completion)
    func update(completion: @escaping Completion)
}
