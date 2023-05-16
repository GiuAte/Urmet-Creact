//
//  LocalPlaceLoader.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 26/07/22.
//

import Foundation

final class LocalPlaceLoader: PlaceLoader {
    private let store: PlaceStore

    enum Error: Swift.Error {
        case retrieveError
    }

    init(store: PlaceStore) {
        self.store = store
    }

    func get(completion: @escaping Completion) {
        store.retrieve { [weak self] result in
            guard let _ = self else { return }

            guard let places = try? result.get() else {
                return completion(.failure(Error.retrieveError))
            }

            completion(.success(places))
        }
    }

    func update(completion: @escaping Completion) {
        get(completion: completion)
    }
}
