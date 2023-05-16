//
//  MessageSipClient.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 06/09/22.
//

import Foundation

protocol SendReceiveMessageSipClient: AnyObject {
    typealias Completion = (Result) -> Void
    typealias Result = Swift.Result<Data, Error>

    func send(_ message: Data, to destinationUri: String, completion: @escaping Completion)
    func didReceive(message: Data)
}
