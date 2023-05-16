//
//  LocalTerminatingCallState.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 14/11/22.
//

import Foundation

final class LocalTerminatingCallState: BaseCallState, ICallState {
    init(callController: ICallController) {
        super.init(callController: callController, stateKey: .localTerminatingCall)
    }

    func onEnter(event: CMEvent, session: SessionData) {
        guard let calleeInfo = session.calleeInfo else {
            return sendEvent(event: CMEvent(eventType: .CALLEEINFO_MISSING_ERROR, callIdentifier: event.callIdentifier))
        }

        sendSipAction(sipAction: SipAction(sipActionType: .CANCEL_CALL_REQ, calleeInfo: calleeInfo, callIdentifier: event.callIdentifier, uniqueUri: session.uniqueUri))
    }

    func onMessageReceived(event: CMEvent, session: SessionData) {
        super.manageUnhandledMessageReceived(event: event, session: session)
    }

    func onExit(event _: CMEvent, session _: SessionData) {}
}
