//
//  SharedUsersService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 03/10/22.
//

import Foundation

public class SharedUsersService: ISharedUsersService {
    private let getUsersService: IGetSharedUsersService
    private let deleteUserService: IDeleteSharedUserService
    private let tokenGeneratorService: ISharingTokenGeneratorService

    public enum Error: Swift.Error {
        case invalidData
        case unauthorized
        case connectivity
        case invalidPlaceUser
        case invalidPlace
    }

    init(getSharedUsersService: IGetSharedUsersService, deleteSharedUserService: IDeleteSharedUserService, sharingTokenGeneratorService: ISharingTokenGeneratorService) {
        getUsersService = getSharedUsersService
        deleteUserService = deleteSharedUserService
        tokenGeneratorService = sharingTokenGeneratorService
    }

    public func getSharingUsers(forPlace place: Place, completion: @escaping (ISharedUsersService.GetUsersResult) -> Void) {
        getUsersService.get(forPlace: place) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error as GetSharedUsersService.Error):
                return completion(.failure(self.map(error: error)))
            case let .success(users):
                return completion(.success(users))
            case .failure:
                break
            }
        }
    }

    private func map(error: GetSharedUsersService.Error) -> SharedUsersService.Error {
        switch error {
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        case .invalidPlace:
            return .invalidPlace
        }
    }

    public func removeSharing(forPlaceUser user: PlaceUser, completion: @escaping (ISharedUsersService.RemoveUserResult) -> Void) {
        deleteUserService.delete(placeUser: user) { [weak self] error in
            guard let self = self else { return }
            if let error = error as? DeleteSharedUserService.Error {
                completion(self.map(error: error))
            } else {
                completion(nil)
            }
        }
    }

    private func map(error: DeleteSharedUserService.Error) -> SharedUsersService.Error {
        switch error {
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        case .invalidPlaceUser:
            return .invalidPlaceUser
        }
    }

    public func generateSharingToken(asPlaceUser user: PlaceUser, completion: @escaping (ISharedUsersService.GenerateTokenResult) -> Void) {
        tokenGeneratorService.generate(asPlaceUser: user) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error as SharingTokenGeneratorService.Error):
                return completion(.failure(self.map(error: error)))
            case let .success(users):
                return completion(.success(users))
            case .failure:
                break
            }
        }
    }

    private func map(error: SharingTokenGeneratorService.Error) -> SharedUsersService.Error {
        switch error {
        case .invalidPlaceUser:
            return .invalidPlaceUser
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        }
    }
}
