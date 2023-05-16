//
//  IGDPRService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 11/10/22.
//

import Foundation

public protocol IGDPRService {
    typealias Result = Swift.Result<[GDPRStatement], Error>
    typealias Completion = (Result) -> Void

    func getStatements(completion: @escaping Completion)
}
