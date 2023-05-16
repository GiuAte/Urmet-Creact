//
//  ISharingTokenGeneratorService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 04/10/22.
//

import Foundation

protocol ISharingTokenGeneratorService {
    typealias Result = Swift.Result<SharingToken, Error>
    typealias Completion = (Result) -> Void

    func generate(asPlaceUser user: PlaceUser, completion: @escaping ISharingTokenGeneratorService.Completion)
}
