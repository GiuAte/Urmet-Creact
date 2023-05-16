//
//  IpercomGatewayUpdater.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 21/11/22.
//

import Foundation

final class IpercomGatewayUpdater: IIpercomGatewayUpdater {
    private let store: PlaceStore
    private let ipercomGetGatewayService: IIpercomGetGatewayService

    init(store: PlaceStore, ipercomGetGatewayService: IIpercomGetGatewayService) {
        self.store = store
        self.ipercomGetGatewayService = ipercomGetGatewayService
    }

    func update(forPlace place: Place, completion: @escaping Completion) {
        ipercomGetGatewayService.getGateway(for: place) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(gateway):
                self.update(place: place, withGateway: gateway, completion: completion)

            case let .failure(error):
                completion(.failure(self.map(error)))
            }
        }
    }

    private func update(place: Place, withGateway gateway: String, completion: @escaping Completion) {
        var updatedPlace = place
        updatedPlace.ipercomGatewayUri = gateway
        store.update(updatedPlace) { error in
            if error != nil {
                return completion(.failure(IpercomGatewayUpdaterError.retrieveError))
            }

            completion(.success(gateway))
        }
    }

    private func map(_ error: IpercomGetGatewayServiceError) -> IpercomGatewayUpdaterError {
        switch error {
        case .uniqueAccountNotFound:
            return .uniqueAccountNotFound
        case .invalidPlace:
            return .invalidPlace
        case .clientError:
            return .clientError
        case .invalidData:
            return .invalidData
        }
    }
}
