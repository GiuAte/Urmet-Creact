//
//  CompositeContactsService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/12/22.
//

import Foundation

class CompositeContactsService: IContactsService {
    private let localLoader: IContactsLoader
    private let remoteLoader: IDevicesLoader

    enum Error: Swift.Error {
        case internalError
        case invalidPlace
        case unsupportedPlace
        case invalidData
        case retrieveError
        case insertError
        case generic
    }

    init(localLoader: IContactsLoader, remoteLoader: IDevicesLoader) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
    }

    func get(forPlace place: Place, completion: @escaping Completion) {
        localLoader.get(forPlace: place) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(contacts):
                completion(.success(contacts))
            case let .failure(error as LocalContactsLoader.Error):
                completion(.failure(self.map(error)))
            case .failure:
                completion(.failure(Error.generic))
            }
        }
    }

    func update(forPlace place: Place, completion: @escaping Completion) {
        remoteLoader.update(forPlace: place) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(devices):
                completion(.success(devices.filter { $0.type.isContact }.map { Contact(device: $0) }))
            case let .failure(error as RemoteDevicesLoader.Error):
                completion(.failure(self.map(error)))
            case let .failure(error as LocalDevicesSaver.Error):
                completion(.failure(self.map(error)))
            case .failure:
                completion(.failure(Error.generic))
            }
        }
    }

    private func map(_ error: LocalContactsLoader.Error) -> Error {
        switch error {
        case .retrieveError:
            return .retrieveError
        }
    }

    private func map(_ error: RemoteDevicesLoader.Error) -> Error {
        switch error {
        case .internalError:
            return .internalError
        case .invalidPlace:
            return .invalidPlace
        case .unsupportedPlace:
            return .unsupportedPlace
        case .invalidData:
            return .invalidData
        }
    }

    private func map(_ error: LocalDevicesSaver.Error) -> Error {
        switch error {
        case .insertError:
            return .insertError
        }
    }
}
