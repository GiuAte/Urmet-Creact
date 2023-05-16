//
//  NWTCPClient.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 10/10/22.
//

import Network

public final class NWTCPClient: TCPClient {
    private let host: NWEndpoint.Host
    private let port: NWEndpoint.Port
    private let parameters: NWParameters
    private var connection: NWConnection?

    private var openConnectionCompletion: OpenConnectionCompletion?
    private var closeConnectionCompletion: CloseConnectionCompletion?

    private let connectionEventQueue = DispatchQueue(label: "\(NWTCPClient.self).event.queue")

    public init(host: NWEndpoint.Host, port: NWEndpoint.Port, parameters: NWParameters = .tcp) {
        self.host = host
        self.port = port
        self.parameters = parameters
    }

    public enum Error: Swift.Error {
        case connectionNotReady
        case write
        case read
    }

    public func openConnection(completion: @escaping OpenConnectionCompletion) {
        openConnectionCompletion = completion
        connection = NWConnection(host: host, port: port, using: parameters)
        connection?.stateUpdateHandler = onConnectionStateUpdate
        connection?.start(queue: connectionEventQueue)
    }

    public func closeConnection(completion: @escaping CloseConnectionCompletion) {
        closeConnectionCompletion = completion
        connection?.cancel()
    }

    public func write(_ data: Data, completion: @escaping WriteCompletion) {
        guard let connection = connection, connection.state == .ready else {
            return completion(Error.connectionNotReady)
        }

        connection.send(content: data, contentContext: .finalMessage, completion: .contentProcessed { error in
            completion(error == nil ? nil : Error.write)
        })
    }

    public func read(completion: @escaping ReadCompletion) {
        guard let connection = connection, connection.state == .ready else {
            return completion(.failure(Error.connectionNotReady))
        }

        connection.receive(minimumIncompleteLength: 1, maximumLength: ._32_KB) { data, _, _, readError in
            guard readError == nil, let data = data else {
                return completion(.failure(Error.read))
            }

            completion(.success(data))
        }
    }

    private func onConnectionStateUpdate(_ state: NWConnection.State) {
        switch state {
        case .ready:
            openConnectionCompletion?(nil)
            openConnectionCompletion = nil

        case let .failed(error):
            openConnectionCompletion?(error)
            openConnectionCompletion = nil

        case .cancelled:
            closeConnectionCompletion?(nil)
            closeConnectionCompletion = nil

        default:
            break
        }
    }
}

private extension Int {
    static var _32_KB: Int { return 32 * 1024 }
}
