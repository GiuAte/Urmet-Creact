//
//  IdleState.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 07/11/22.
//

import Foundation

final class IdleState: BaseCallState, ICallState {
    init(callController: ICallController) {
        super.init(callController: callController, stateKey: .idle)
    }

    func onEnter(event _: CMEvent, session: SessionData) {
        session.cleanUp()
        super.clearSipIdentifier()
    }

    func onMessageReceived(event: CMEvent, session: SessionData) {
        switch event.eventType {
        case .IPERCOM_AUTO_INS_REQ, .IPERCOM_EMERG_CALL_REQ, .IPERCOM_INTERCOM_CALL_REQ:
            guard let calleeInfo = event.calleeInfo else {
                return sendEvent(event: CMEvent(eventType: .CALLEEINFO_MISSING_ERROR, callIdentifier: event.callIdentifier))
            }

            session.calleeInfo = calleeInfo
            sendEvent(event: CMEvent(eventType: .BEGIN_CALL_ME_BACK, callIdentifier: event.callIdentifier))
        case .SIP_INCOMING_CALL:
            guard let remoteUri = event.callIdentifier.remoteUri else {
                return sendEvent(event: CMEvent(eventType: .URI_MISSING_ERROR, callIdentifier: event.callIdentifier))
            }

            session.remoteUri = remoteUri
        default:
            super.manageUnhandledMessageReceived(event: event, session: session)
        }
    }

    func onExit(event _: CMEvent, session _: SessionData) {}
}
