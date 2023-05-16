//
//  CoreManager.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 21/10/22.
//

import Foundation

public struct CoreConfiguration {
    let dnsServers: [String]
    let enableStun: Bool
    let stunServer: String?
    let callTimeout: Int
    let incomingCallTimeout: Int
    let randomPorts: Bool

    static let standard: CoreConfiguration = .init(
        dnsServers: ["8.8.8.8", "8.8.4.4"],
        enableStun: false,
        stunServer: nil,
        callTimeout: 120,
        incomingCallTimeout: 60,
        randomPorts: true
    )
}

public enum CoreManagerError: Swift.Error {
    case coreAlreadyStarted
    case cannotStartCore
    case coreAlreadyStopped
}

protocol CoreManager {
    typealias Result = CoreManagerError?
    typealias Completion = (Result) -> Void

    func start(completion: @escaping Completion)
    func stop(completion: @escaping Completion)
    func configure(config: CoreConfiguration)
}
