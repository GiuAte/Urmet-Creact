//
//  IIpercomGetGatewayService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 15/12/22.
//

import Foundation

enum IpercomGetGatewayServiceError: Swift.Error {
    case uniqueAccountNotFound
    case invalidPlace
    case clientError
    case invalidData
}

protocol IIpercomGetGatewayService {
    typealias Gateway = String
    typealias Result = Swift.Result<Gateway, IpercomGetGatewayServiceError>
    typealias Completion = (Result) -> Void

    func getGateway(for place: Place, completion: @escaping Completion)
}
