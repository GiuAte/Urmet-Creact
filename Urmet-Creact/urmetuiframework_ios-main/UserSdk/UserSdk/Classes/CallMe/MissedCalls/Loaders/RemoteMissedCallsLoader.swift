//
//  RemoteMissedCallsLoader.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 18/11/22.
//

import Foundation

final class RemoteMissedCallsLoader: IMissedCallsLoader {
    private let missedCallsServices: [PlaceStrategy: IMissedCallsSipService]
    private let uniqueSipAccountService: IUniqueSipAccountService

    enum Error: Swift.Error {
        case internalError
        case invalidPlace
        case unsupportedPlace
        case invalidData
    }

    init(missedCallsServices: [PlaceStrategy: IMissedCallsSipService], uniqueSipAccountService: IUniqueSipAccountService) {
        self.missedCallsServices = missedCallsServices
        self.uniqueSipAccountService = uniqueSipAccountService
    }

    func get(forPlace place: Place, completion: @escaping Completion) {
        guard let loader = getLoader(forPlace: place) else { return completion(.failure(Error.unsupportedPlace)) }

        uniqueSipAccountService.get { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(account):
                let responseUri = account.getUri()
                self.getMissedCalls(forPlace: place, withLoader: loader, andReplyTo: responseUri, completion: completion)
            case .failure:
                return completion(.failure(Error.internalError))
            }
        }
    }

    func update(forPlace place: Place, completion: @escaping Completion) {
        get(forPlace: place, completion: completion)
    }

    private func getMissedCalls(forPlace place: Place, withLoader loader: IMissedCallsSipService, andReplyTo responseUri: String, completion: @escaping Completion) {
        loader.getMissedCalls(for: place, andReplyTo: responseUri) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(missedCalls):
                return completion(.success(missedCalls))

            case let .failure(error as IpercomGetMissedCallsSipService.Error):
                return completion(.failure(self.map(error)))

            case .failure:
                return completion(.failure(Error.internalError))
            }
        }
    }

    private func getLoader(forPlace place: Place) -> IMissedCallsSipService? {
        if let strategy = place.strategies.filter({ strategy in missedCallsServices.contains(where: { $0.key == strategy }) }).first {
            return missedCallsServices[strategy]
        }

        return nil
    }

    private func map(_ error: IpercomGetMissedCallsSipService.Error) -> Error {
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
