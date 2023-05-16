//
//  RemoteAlarmsLoader.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 22/12/22.
//

import Foundation

final class RemoteAlarmsLoader: IAlarmsLoader {
    private let alarmsServices: [PlaceStrategy: IGetAlarmsSipService]
    private let uniqueSipAccountService: IUniqueSipAccountService

    enum Error: Swift.Error {
        case internalError
        case invalidPlace
        case unsupportedPlace
        case invalidData
    }

    init(alarmsServices: [PlaceStrategy: IGetAlarmsSipService], uniqueSipAccountService: IUniqueSipAccountService) {
        self.alarmsServices = alarmsServices
        self.uniqueSipAccountService = uniqueSipAccountService
    }

    func get(forPlace place: Place, completion: @escaping Completion) {
        guard let loader = getLoader(forPlace: place) else { return completion(.failure(Error.unsupportedPlace)) }

        uniqueSipAccountService.get { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(account):
                let responseUri = account.getUri()
                self.getAlarms(forPlace: place, withLoader: loader, andReplyTo: responseUri, completion: completion)
            case .failure:
                return completion(.failure(Error.internalError))
            }
        }
    }

    private func getAlarms(forPlace place: Place, withLoader loader: IGetAlarmsSipService, andReplyTo responseUri: String, completion: @escaping Completion) {
        loader.getAlarms(for: place, andReplyTo: responseUri) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(alarms):
                return completion(.success(alarms))

            case let .failure(error as IpercomGetAlarmsSipService.Error):
                return completion(.failure(self.map(error)))

            case .failure:
                return completion(.failure(Error.internalError))
            }
        }
    }

    private func getLoader(forPlace place: Place) -> IGetAlarmsSipService? {
        if let strategy = place.strategies.filter({ strategy in alarmsServices.contains(where: { $0.key == strategy }) }).first {
            return alarmsServices[strategy]
        }

        return nil
    }

    func update(forPlace place: Place, completion: @escaping Completion) {
        get(forPlace: place, completion: completion)
    }

    private func map(_ error: IpercomGetAlarmsSipService.Error) -> Error {
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
