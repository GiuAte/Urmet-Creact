//
//  LocalDevicesSaver.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/12/22.
//

import Foundation

class LocalDevicesSaver: IDevicesSaver {
    private let store: DevicesStore

    init(store: DevicesStore) {
        self.store = store
    }

    enum Error: Swift.Error {
        case insertError
    }

    func insert(_ devices: [Device], forPlace place: Place, completion: @escaping InsertCompletion) {
        store.delete(forPlace: place) { [weak self] error in
            guard let self else { return }

            guard error == nil else {
                return completion(Error.insertError)
            }

            self.store.insert(devices, forPlace: place) { error in
                guard error == nil else {
                    return completion(Error.insertError)
                }

                completion(nil)
            }
        }
    }
}
