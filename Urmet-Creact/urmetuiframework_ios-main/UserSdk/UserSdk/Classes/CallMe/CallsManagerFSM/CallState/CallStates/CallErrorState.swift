//
//  CallErrorState.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 16/11/22.
//

import Foundation

final class CallErrorState: BaseCallState, ICallState {
    init(callController: ICallController) {
        super.init(callController: callController, stateKey: .callError)
    }

    func onEnter(event: CMEvent, session _: SessionData) {
        sendAppAction(appAction: AppAction(appActionType: .SERVICE_UNAVAILABLE(reason: event.eventType.rawValue)))
        sendEvent(event: CMEvent(eventType: .SIP_CALL_RELEASED, callIdentifier: event.callIdentifier))
    }

    func onMessageReceived(event: CMEvent, session: SessionData) {
        super.manageUnhandledMessageReceived(event: event, session: session)
    }

    func onExit(event _: CMEvent, session _: SessionData) {}
}
