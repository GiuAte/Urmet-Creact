//
//  MissedCallsStore.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 16/12/22.
//

import Foundation

protocol MissedCallsStore {
    typealias Result = Swift.Result<[MissedCall], Error>
    typealias RetrieveCompletion = (Result) -> Void
    typealias InsertCompletion = (Error?) -> Void
    typealias DeleteCompletion = (Error?) -> Void

    func retrieve(forPlace place: Place, completion: @escaping RetrieveCompletion)
    func insert(_ missedCalls: [MissedCall], forPlace place: Place, completion: @escaping InsertCompletion)
    func delete(forPlace place: Place, completion: @escaping DeleteCompletion)
    func clear(completion: @escaping DeleteCompletion)
}
