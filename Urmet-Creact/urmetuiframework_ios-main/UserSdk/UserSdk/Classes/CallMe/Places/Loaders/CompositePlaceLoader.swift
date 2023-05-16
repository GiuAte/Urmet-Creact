//
//  CompositePlaceLoader.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 05/08/22.
//

import Foundation

final class CompositePlaceLoader: PlaceLoader {
    private let localLoader: PlaceLoader
    private let remoteLoader: PlaceLoader

    init(localLoader: PlaceLoader, remoteLoader: PlaceLoader) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
    }

    func get(completion: @escaping Completion) {
        localLoader.get { result in
            completion(result)
        }
    }

    func update(completion: @escaping Completion) {
        remoteLoader.update { result in
            completion(result)
        }
    }
}
