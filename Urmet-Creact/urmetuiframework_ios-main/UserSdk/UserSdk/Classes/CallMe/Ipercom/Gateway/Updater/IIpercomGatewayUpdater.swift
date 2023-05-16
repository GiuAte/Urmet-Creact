//
//  IIpercomGatewayUpdater.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 21/11/22.
//

import Foundation

enum IpercomGatewayUpdaterError: Swift.Error {
    case invalidPlace
    case uniqueAccountNotFound
    case retrieveError
    case clientError
    case invalidData
}

protocol IIpercomGatewayUpdater {
    typealias Result = Swift.Result<String, IpercomGatewayUpdaterError>
    typealias Completion = (Result) -> Void

    func update(forPlace place: Place, completion: @escaping Completion)
}
