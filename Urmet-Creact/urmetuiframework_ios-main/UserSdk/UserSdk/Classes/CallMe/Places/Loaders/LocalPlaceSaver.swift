//
//  LocalPlaceSaver.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 06/10/22.
//

import Foundation

final class LocalPlaceSaver: PlaceSaver {
    private let store: PlaceStore

    enum Error: Swift.Error {
        case insertError
    }

    struct PartialInsertResult {
        let totalCount: Int
        let completion: PlaceSaver.Completion
        var lastError: Error?
        var currentCount: Int = 0 {
            didSet {
                checkCompletion()
            }
        }

        func checkCompletion() {
            if currentCount == totalCount {
                if lastError != nil {
                    completion(Error.insertError)
                } else {
                    completion(nil)
                }
            }
        }
    }

    init(store: PlaceStore) {
        self.store = store
    }

    func insert(_ places: [Place], completion: @escaping Completion) {
        store.clear { [weak self] error in
            guard let self = self else { return }

            if error != nil {
                completion(Error.insertError)
                return
            }

            if places.count == 0 {
                completion(nil)
            }

            var partialResult = PartialInsertResult(totalCount: places.count, completion: completion)
            let queue = DispatchQueue(label: "insertQueue")

            for place in places {
                self.store.insert(place) { [weak self] error in
                    guard self != nil else { return }

                    queue.sync {
                        if error != nil {
                            partialResult.lastError = .insertError
                        }
                        partialResult.currentCount += 1
                    }
                }
            }
        }
    }
}
