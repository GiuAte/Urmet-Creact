//
//  CompositeMissedCallsService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 20/12/22.
//

import Foundation

class CompositeMissedCallsService: IMissedCallsService {
    private let localLoader: IMissedCallsLoader
    private let remoteLoader: IMissedCallsLoader

    enum Error: Swift.Error {
        case internalError
        case invalidPlace
        case unsupportedPlace
        case invalidData
        case retrieveError
        case insertError
        case generic
    }

    init(localLoader: IMissedCallsLoader, remoteLoader: IMissedCallsLoader) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
    }

    func get(forPlace place: Place, completion: @escaping Completion) {
        localLoader.get(forPlace: place) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(missedCalls):
                completion(.success(missedCalls))
            case let .failure(error as LocalMissedCallsLoader.Error):
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
            case let .success(missedCalls):
                completion(.success(missedCalls))
            case let .failure(error as RemoteMissedCallsLoader.Error):
                completion(.failure(self.map(error)))
            case let .failure(error as LocalMissedCallsSaver.Error):
                completion(.failure(self.map(error)))
            case .failure:
                completion(.failure(Error.generic))
            }
        }
    }

    private func map(_ error: LocalMissedCallsLoader.Error) -> Error {
        switch error {
        case .retrieveError:
            return .retrieveError
        }
    }

    private func map(_ error: RemoteMissedCallsLoader.Error) -> Error {
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

    private func map(_ error: LocalMissedCallsSaver.Error) -> Error {
        switch error {
        case .insertError:
            return .insertError
        }
    }
}
