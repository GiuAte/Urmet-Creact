//
//  IGetSharedUsersService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 03/10/22.
//

import Foundation

protocol IGetSharedUsersService {
    typealias Result = Swift.Result<[PlaceUser], Error>

    func get(forPlace place: Place, completion: @escaping (Result) -> Void)
}
