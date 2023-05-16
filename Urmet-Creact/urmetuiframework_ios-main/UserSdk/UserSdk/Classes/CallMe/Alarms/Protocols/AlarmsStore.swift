//
//  AlarmsStore.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 22/12/22.
//

import Foundation

protocol AlarmsStore {
    typealias Result = Swift.Result<[Alarm], Error>
    typealias RetrieveCompletion = (Result) -> Void
    typealias InsertCompletion = (Error?) -> Void
    typealias DeleteCompletion = (Error?) -> Void

    func retrieve(forPlace place: Place, completion: @escaping RetrieveCompletion)
    func insert(_ alarms: [Alarm], forPlace place: Place, completion: @escaping InsertCompletion)
    func delete(forPlace place: Place, completion: @escaping InsertCompletion)
    func clear(completion: @escaping DeleteCompletion)
}
