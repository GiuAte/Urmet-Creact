//
//  IIpercomGetGatewaySipService.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 06/09/22.
//

import Foundation

enum IIpercomGetGatewaySipServiceError: Swift.Error {
    case clientError
    case invalidData
    case invalidPlace
}

protocol IIpercomGetGatewaySipService {
    typealias Gateway = String
    typealias Result = Swift.Result<Gateway, IIpercomGetGatewaySipServiceError>
    typealias Completion = (Result) -> Void

    func getGateway(for place: Place, andReplyTo responseUri: String, completion: @escaping Completion)
}
