//
//  RemoteDevicesLoader.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 27/12/22.
//

import Foundation

class RemoteDevicesLoader: IDevicesLoader {
    private let devicesServices: [PlaceStrategy: IGetDevicesSipService]
    private let uniqueSipAccountService: IUniqueSipAccountService

    enum Error: Swift.Error {
        case internalError
        case invalidPlace
        case unsupportedPlace
        case invalidData
    }

    init(devicesServices: [PlaceStrategy: IGetDevicesSipService], uniqueSipAccountService: IUniqueSipAccountService) {
        self.devicesServices = devicesServices
        self.uniqueSipAccountService = uniqueSipAccountService
    }

    func get(forPlace place: Place, completion: @escaping Completion) {
        guard let loader = getLoader(forPlace: place) else { return completion(.failure(Error.unsupportedPlace)) }

        uniqueSipAccountService.get { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(account):
                let responseUri = account.getUri()
                self.getDevices(forPlace: place, withLoader: loader, andReplyTo: responseUri, completion: completion)
            case .failure:
                return completion(.failure(Error.internalError))
            }
        }
    }

    private func getDevices(forPlace place: Place, withLoader loader: IGetDevicesSipService, andReplyTo responseUri: String, completion: @escaping Completion) {
        loader.getDevices(for: place, andReplyTo: responseUri) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(devices):
                return completion(.success(devices))

            case let .failure(error as IpercomGetDevicesSipService.Error):
                return completion(.failure(self.map(error)))

            case .failure:
                return completion(.failure(Error.internalError))
            }
        }
    }

    private func getLoader(forPlace place: Place) -> IGetDevicesSipService? {
        if let strategy = place.strategies.filter({ strategy in devicesServices.contains(where: { $0.key == strategy }) }).first {
            return devicesServices[strategy]
        }

        return nil
    }

    func update(forPlace place: Place, completion: @escaping Completion) {
        get(forPlace: place, completion: completion)
    }

    private func map(_ error: IpercomGetDevicesSipService.Error) -> Error {
        switch error {
        case .missingAccount:
            return .invalidPlace
        case .clientError:
            return .internalError
        case .invalidData:
            return .invalidData
        }
    }
}
