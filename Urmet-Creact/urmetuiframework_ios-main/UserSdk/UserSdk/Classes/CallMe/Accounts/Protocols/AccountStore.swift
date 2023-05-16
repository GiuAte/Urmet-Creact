//
//  AccountStore.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 01/07/22.
//

import Foundation

protocol AccountStore {
    typealias Result = Swift.Result<[Account], Error>
    typealias Completion = (Result) -> Void

    typealias InsertCompletion = (Error?) -> Void
    typealias DeleteCompletion = (Error?) -> Void

    func insert(account: Account, completion: @escaping InsertCompletion)
    func retrieve(completion: @escaping Completion)
    func delete(account: Account, completion: @escaping DeleteCompletion)
}
