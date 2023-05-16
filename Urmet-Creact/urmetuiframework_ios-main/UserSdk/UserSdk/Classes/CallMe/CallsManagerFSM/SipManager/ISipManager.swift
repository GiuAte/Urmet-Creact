//
//  ISipManager.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 09/12/22.
//

import Foundation

protocol ISipManager {
    typealias Callback = (SipMessage) -> Void

    func addSipMessageReceiver(callback: @escaping Callback)
    func executeSipAction(sipAction: SipAction)
}
