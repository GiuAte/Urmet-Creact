//
//  CompositeAlarmsService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 23/12/22.
//

import Foundation

class CompositeAlarmsService: IAlarmsService {
    private let localLoader: IAlarmsLoader
    private let remoteLoader: IAlarmsLoader

    enum Error: Swift.Error {
        case internalError
        case invalidPlace
        case unsupportedPlace
        case invalidData
        case retrieveError
        case insertError
        case generic
    }

    init(localLoader: IAlarmsLoader, remoteLoader: IAlarmsLoader) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
    }

    func get(forPlace place: Place, completion: @escaping Completion) {
        localLoader.get(forPlace: place) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(alarms):
                completion(.success(alarms))
            case let .failure(error as LocalAlarmsLoader.Error):
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
            case let .success(alarms):
                completion(.success(alarms))
            case let .failure(error as RemoteAlarmsLoader.Error):
                completion(.failure(self.map(error)))
            case let .failure(error as LocalAlarmsSaver.Error):
                completion(.failure(self.map(error)))
            case .failure:
                completion(.failure(Error.generic))
            }
        }
    }

    private func map(_ error: LocalAlarmsLoader.Error) -> Error {
        switch error {
        case .retrieveError:
            return .retrieveError
        }
    }

    private func map(_ error: RemoteAlarmsLoader.Error) -> Error {
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

    private func map(_ error: LocalAlarmsSaver.Error) -> Error {
        switch error {
        case .insertError:
            return .insertError
        }
    }
}
