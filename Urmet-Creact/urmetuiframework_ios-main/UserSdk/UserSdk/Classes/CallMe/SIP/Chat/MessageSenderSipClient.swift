//
//  MessageSenderSipClient.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 15/09/22.
//

import Foundation

protocol MessageSenderSipClient {
    typealias Completion = (Result) -> Void
    typealias Result = Error?

    func send(_ message: Data, to destinationUri: String, completion: @escaping Completion)
}
