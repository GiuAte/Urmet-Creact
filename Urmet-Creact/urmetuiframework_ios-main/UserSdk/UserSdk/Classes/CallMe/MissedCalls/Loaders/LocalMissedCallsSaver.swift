//
//  LocalMissedCallsSaver.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 27/12/22.
//

import Foundation

class LocalMissedCallsSaver: IMissedCallsSaver {
    private let store: MissedCallsStore

    init(store: MissedCallsStore) {
        self.store = store
    }

    enum Error: Swift.Error {
        case insertError
    }

    func insert(_ missedCalls: [MissedCall], forPlace place: Place, completion: @escaping InsertCompletion) {
        store.delete(forPlace: place) { [weak self] error in
            guard let self else { return }

            guard error == nil else {
                return completion(Error.insertError)
            }

            self.store.insert(missedCalls, forPlace: place) { error in
                guard error == nil else {
                    return completion(Error.insertError)
                }

                completion(nil)
            }
        }
    }
}
