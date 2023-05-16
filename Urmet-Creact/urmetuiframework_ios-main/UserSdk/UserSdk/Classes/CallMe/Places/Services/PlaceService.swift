//
//  PlaceService.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 22/06/22.
//

import Foundation

public final class PlaceService: IPlaceService {
    private let loader: PlaceLoader
    private let adder: PlaceAdder
    private let remover: IRelationRemoverService
    private let enabler: IPlaceEnablerService

    public enum Error: Swift.Error {
        case connectivity
        case generic
        case unauthorized
        case invalidQR
        case invalidData
        case invalidPlace
        case masterAlreadySet
        case expiredQR
    }

    init(loader: PlaceLoader, adder: PlaceAdder, remover: IRelationRemoverService, enabler: IPlaceEnablerService) {
        self.loader = loader
        self.adder = adder
        self.remover = remover
        self.enabler = enabler
    }

    public func get(completion: @escaping (IPlaceService.GetResult) -> Void) {
        loader.get { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .failure(error as RemotePlaceLoader.Error):
                completion(self.map(error))

            case let .success(places):
                completion(.success(places))

            case .failure:
                return completion(.failure(PlaceService.Error.generic))
            }
        }
    }

    public func update(completion: @escaping (GetResult) -> Void) {
        loader.update { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .failure(error as RemotePlaceLoader.Error):
                completion(self.map(error))

            case let .success(places):
                completion(.success(places))

            case .failure:
                return completion(.failure(PlaceService.Error.generic))
            }
        }
    }

    private func map(_ error: RemotePlaceLoader.Error) -> IPlaceService.GetResult {
        switch error {
        case .connectivity:
            return .failure(PlaceService.Error.connectivity)
        case .unauthorized:
            return .failure(PlaceService.Error.unauthorized)
        default:
            return .failure(PlaceService.Error.generic)
        }
    }

    public func add(fromQRCode qr: String, completion: @escaping (AddResult) -> Void) {
        adder.add(fromQRCode: qr) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .failure(error as RemotePlaceAdder.Error):
                completion(.failure(self.map(error: error)))
            case .failure:
                completion(.failure(PlaceService.Error.generic))
            case let .success(place):
                completion(.success(place))
            }
        }
    }

    private func map(error: RemotePlaceAdder.Error) -> PlaceService.Error {
        switch error {
        case .invalidQR:
            return PlaceService.Error.invalidQR
        case .connectivity:
            return PlaceService.Error.connectivity
        case .unauthorized:
            return PlaceService.Error.unauthorized
        case .invalidData:
            return PlaceService.Error.invalidData
        case .masterAlreadySet:
            return PlaceService.Error.masterAlreadySet
        case .generic:
            return PlaceService.Error.generic
        case .expiredQR:
            return PlaceService.Error.expiredQR
        }
    }

    public func remove(place: Place, completion: @escaping (RemoveResult) -> Void) {
        guard let channelId = Place.extractSIPIncomingUsername(place: place),
              let uid = place.uid
        else {
            return completion(PlaceService.Error.invalidPlace)
        }

        remover.remove(deviceWithUID: uid, andChannelId: channelId) { [weak self] error in
            guard let self = self else { return }

            switch error {
            case .none:
                completion(nil)
            case let .some(error as RelationRemoverService.Error):
                completion(self.map(error: error))
            case .some:
                completion(PlaceService.Error.generic)
            }
        }
    }

    private func map(error: RelationRemoverService.Error) -> PlaceService.Error {
        switch error {
        case .connectivity:
            return PlaceService.Error.connectivity
        case .unauthorized:
            return PlaceService.Error.unauthorized
        case .invalidData:
            return PlaceService.Error.invalidData
        }
    }

    public func enable(place: Place, completion: @escaping (EnableResult) -> Void) {
        enabler.enable(place) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                return completion(nil)
            case let .failure(error as PlaceEnablerService.Error):
                return completion(self.map(error))
            case .failure:
                return completion(PlaceService.Error.generic)
            }
        }
    }

    public func disable(place: Place, completion: @escaping (DisableResult) -> Void) {
        enabler.disable(place) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                return completion(nil)
            case let .failure(error as PlaceEnablerService.Error):
                return completion(self.map(error))
            case .failure:
                return completion(PlaceService.Error.generic)
            }
        }
    }

    private func map(_ error: PlaceEnablerService.Error) -> PlaceService.Error {
        switch error {
        case .placeNotFound:
            return .invalidPlace
        case .genericError:
            return .generic
        }
    }
}
