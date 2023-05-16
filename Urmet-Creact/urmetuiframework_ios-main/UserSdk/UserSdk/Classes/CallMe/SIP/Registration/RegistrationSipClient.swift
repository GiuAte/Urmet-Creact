//
//  RegistrationSipClient.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 01/09/22.
//

import Foundation

protocol RegistrationSipClient {
    typealias Result = Swift.Result<SipRegistrationState, Error>
    typealias Completion = (Result) -> Void

    func register(_ account: Account, withParams params: RegistrationParams, completion: @escaping Completion)
    func unregister(_ account: Account, completion: @escaping Completion)
}
