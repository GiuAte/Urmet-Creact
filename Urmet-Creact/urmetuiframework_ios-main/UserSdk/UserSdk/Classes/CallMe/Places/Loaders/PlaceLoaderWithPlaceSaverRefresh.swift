//
//  PlaceLoaderWithPlaceSaverRefresh.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 30/09/22.
//

import Foundation

final class PlaceLoaderWithPlaceSaverRefresh: PlaceLoader {
    private let loader: PlaceLoader
    private let saver: PlaceSaver

    init(loader: PlaceLoader, saver: PlaceSaver) {
        self.loader = loader
        self.saver = saver
    }

    func get(completion: @escaping Completion) {
        loader.get { result in
            switch result {
            case let .success(places):
                completion(.success(places))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func update(completion: @escaping Completion) {
        get { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(places):
                self.saver.insert(places) { error in
                    if let error {
                        return completion(.failure(error))
                    }

                    completion(.success(places))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
