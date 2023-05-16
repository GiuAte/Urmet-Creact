//
//  MissedCallsLoaderWithSaver.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 30/11/22.
//

import Foundation

class MissedCallsLoaderWithSaver: IMissedCallsLoader {
    private let loader: IMissedCallsLoader
    private let saver: IMissedCallsSaver

    init(loader: IMissedCallsLoader, saver: IMissedCallsSaver) {
        self.loader = loader
        self.saver = saver
    }

    func get(forPlace place: UserSdk.Place, completion: @escaping Completion) {
        loader.get(forPlace: place) { result in
            switch result {
            case let .success(missedCalls):
                completion(.success(missedCalls))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func update(forPlace place: Place, completion: @escaping Completion) {
        get(forPlace: place) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(missedCalls):
                self.saver.insert(missedCalls, forPlace: place) { error in
                    if let error {
                        return completion(.failure(error))
                    }

                    completion(.success(missedCalls))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
