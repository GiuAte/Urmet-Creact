//
//  IUserSipDataService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 18/10/22.
//

import Foundation

protocol IUserSipDataService {
    typealias GetUserSipDataResult = Swift.Result<UserSipData, Error>
    typealias GetUserSipDataCompletion = (GetUserSipDataResult) -> Void
    typealias SetUserSipDataResult = Swift.Result<Bool, Error>
    typealias SetUserSipDataCompletion = (SetUserSipDataResult) -> Void

    func get(completion: @escaping GetUserSipDataCompletion)
    func set(sipData: UserSipData, completion: @escaping SetUserSipDataCompletion)
}
