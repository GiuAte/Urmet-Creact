//
//  PlaceEnablerService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 09/11/22.
//

import Foundation

protocol IPlaceEnablerService {
    typealias Result = Swift.Result<Bool, Error>
    typealias Completion = (Result) -> Void

    func enable(_ place: Place, completion: @escaping Completion)
    func disable(_ place: Place, completion: @escaping Completion)
}

final class PlaceEnablerService: IPlaceEnablerService {
    private let store: PlaceStore

    enum Error: Swift.Error {
        case placeNotFound
        case genericError
    }

    init(store: PlaceStore) {
        self.store = store
    }

    func enable(_ place: UserSdk.Place, completion: @escaping Completion) {
        var updatedPlace = place
        updatedPlace.enabled = true
        doUpdate(updatedPlace, completion: completion)
    }

    func disable(_ place: UserSdk.Place, completion: @escaping Completion) {
        var updatedPlace = place
        updatedPlace.enabled = false
        doUpdate(updatedPlace, completion: completion)
    }

    private func doUpdate(_ place: UserSdk.Place, completion: @escaping Completion) {
        store.update(place) { error in
            if error == nil {
                return completion(.success(true))
            }

            if error is CoreDataPlaceStore.Error {
                return completion(.failure(PlaceEnablerService.Error.placeNotFound))
            } else {
                return completion(.failure(PlaceEnablerService.Error.genericError))
            }
        }
    }
}
