//
//  LocalMissedCallsLoader.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 19/12/22.
//

import Foundation

class LocalMissedCallsLoader: IMissedCallsLoader {
    private let store: MissedCallsStore

    enum Error: Swift.Error {
        case retrieveError
    }

    init(store: MissedCallsStore) {
        self.store = store
    }

    func get(forPlace place: Place, completion: @escaping Completion) {
        store.retrieve(forPlace: place) { [weak self] result in
            guard let _ = self else { return }

            switch result {
            case let .success(missedCalls):
                completion(.success(missedCalls))
            case .failure:
                completion(.failure(Error.retrieveError))
            }
        }
    }

    func update(forPlace place: Place, completion: @escaping Completion) {
        get(forPlace: place, completion: completion)
    }
}
