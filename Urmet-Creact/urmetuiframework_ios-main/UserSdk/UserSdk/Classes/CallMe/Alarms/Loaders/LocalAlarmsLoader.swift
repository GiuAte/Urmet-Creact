//
//  LocalAlarmsLoader.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 23/12/22.
//

import Foundation

class LocalAlarmsLoader: IAlarmsLoader {
    private let store: AlarmsStore

    enum Error: Swift.Error {
        case retrieveError
    }

    init(store: AlarmsStore) {
        self.store = store
    }

    func get(forPlace place: Place, completion: @escaping Completion) {
        store.retrieve(forPlace: place) { [weak self] result in
            guard let _ = self else { return }

            switch result {
            case let .success(alarms):
                completion(.success(alarms))
            case .failure:
                completion(.failure(Error.retrieveError))
            }
        }
    }

    func update(forPlace place: Place, completion: @escaping Completion) {
        get(forPlace: place, completion: completion)
    }
}
