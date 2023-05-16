//
//  ISharedUsersService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 03/10/22.
//

import Foundation

public protocol ISharedUsersService {
    typealias GetUsersResult = Swift.Result<[PlaceUser], Error>
    typealias RemoveUserResult = Error?
    typealias GenerateTokenResult = Swift.Result<SharingToken, Error>

    func getSharingUsers(forPlace place: Place, completion: @escaping (GetUsersResult) -> Void)
    func removeSharing(forPlaceUser user: PlaceUser, completion: @escaping (RemoveUserResult) -> Void)
    func generateSharingToken(asPlaceUser user: PlaceUser, completion: @escaping (GenerateTokenResult) -> Void)
}
