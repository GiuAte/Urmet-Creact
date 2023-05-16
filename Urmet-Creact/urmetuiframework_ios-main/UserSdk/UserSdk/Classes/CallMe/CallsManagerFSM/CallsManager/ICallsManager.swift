//
//  ICallsManager.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 17/11/22.
//

import Foundation

protocol ICallsManager {
    func insertEvent(_ event: CMEvent)
    func manageSipAction(sipAction: SipAction)
    func manageAppAction(callControllerId: UUID, appAction: AppAction)
}
