//
//  ICallController.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 16/11/22.
//

import Foundation

protocol ICallController {
    func setSipIdentifier(sipUri: String) -> Bool
    func clearSipIdentifier()
    func insertEvent(event: CMEvent) -> Bool
    func manageSipAction(sipAction: SipAction)
    func manageAppAction(appAction: AppAction)
}
