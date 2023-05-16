//
//  PlaceStore.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 01/07/22.
//

import Foundation

protocol PlaceStore {
    typealias Result = Swift.Result<[Place], Error>
    typealias RetrieveCompletion = (Result) -> Void
    typealias InsertCompletion = (Error?) -> Void
    typealias DeleteCompletion = (Error?) -> Void
    typealias UpdateCompletion = (Error?) -> Void

    func retrieve(completion: @escaping RetrieveCompletion)
    func insert(_ place: Place, completion: @escaping InsertCompletion)
    func delete(_ place: Place, completion: @escaping DeleteCompletion)
    func update(_ place: Place, completion: @escaping UpdateCompletion)
    func clear(completion: @escaping DeleteCompletion)
}
