//
//  DevicesLoaderWithSaver.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/12/22.
//

import Foundation

class DevicesLoaderWithSaver: IDevicesLoader {
    private let loader: IDevicesLoader
    private let saver: IDevicesSaver

    init(loader: IDevicesLoader, saver: IDevicesSaver) {
        self.loader = loader
        self.saver = saver
    }

    func get(forPlace place: UserSdk.Place, completion: @escaping Completion) {
        loader.get(forPlace: place) { result in
            switch result {
            case let .success(devices):
                completion(.success(devices))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func update(forPlace place: Place, completion: @escaping Completion) {
        get(forPlace: place) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(devices):
                self.saver.insert(devices, forPlace: place) { error in
                    if let error {
                        return completion(.failure(error))
                    }

                    completion(.success(devices))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
