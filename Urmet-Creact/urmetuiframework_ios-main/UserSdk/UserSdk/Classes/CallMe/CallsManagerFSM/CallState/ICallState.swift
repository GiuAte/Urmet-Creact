//
//  ICallState.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 07/11/22.
//

import Foundation

protocol ICallState {
    func onEnter(event: CMEvent, session: SessionData)
    func onMessageReceived(event: CMEvent, session: SessionData)
    func onExit(event: CMEvent, session: SessionData)
}
