//
//  IDeleteSharedUserService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 04/10/22.
//

import Foundation

protocol IDeleteSharedUserService {
    typealias Result = Error?

    func delete(placeUser: PlaceUser, completion: @escaping (Result) -> Void)
}
