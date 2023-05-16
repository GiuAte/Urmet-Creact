//
//  TCPClient.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 30/09/22.
//

import Foundation

public protocol TCPClient {
    typealias OpenConnectionCompletion = (Error?) -> Void
    typealias CloseConnectionCompletion = (Error?) -> Void
    typealias WriteCompletion = (Error?) -> Void
    typealias ReadCompletion = (Result<Data, Error>) -> Void

    func openConnection(completion: @escaping OpenConnectionCompletion)
    func closeConnection(completion: @escaping CloseConnectionCompletion)
    func write(_ data: Data, completion: @escaping WriteCompletion)
    func read(completion: @escaping ReadCompletion)
}
