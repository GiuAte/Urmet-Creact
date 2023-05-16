//
//  LocalCamerasLoader.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/12/22.
//

import Foundation

class LocalCamerasLoader: ICamerasLoader {
    private let store: DevicesStore

    enum Error: Swift.Error {
        case retrieveError
    }

    init(store: DevicesStore) {
        self.store = store
    }

    func get(forPlace place: Place, completion: @escaping Completion) {
        store.retrieveCameras(forPlace: place) { [weak self] result in
            guard let _ = self else { return }

            switch result {
            case let .success(cameras):
                completion(.success(cameras))
            case .failure:
                completion(.failure(Error.retrieveError))
            }
        }
    }

    func update(forPlace place: Place, completion: @escaping Completion) {
        get(forPlace: place, completion: completion)
    }
}
