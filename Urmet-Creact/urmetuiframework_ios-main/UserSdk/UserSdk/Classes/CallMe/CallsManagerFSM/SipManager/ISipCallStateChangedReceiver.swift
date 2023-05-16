//
//  ISipCallStateChangedReceiver.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 29/11/22.
//

import Foundation

protocol ISipCallStateChangedReceiver {
    typealias Completion = (SipMessage) -> Void

    func addCallStateChangedCallback(callback: @escaping Completion)
}
