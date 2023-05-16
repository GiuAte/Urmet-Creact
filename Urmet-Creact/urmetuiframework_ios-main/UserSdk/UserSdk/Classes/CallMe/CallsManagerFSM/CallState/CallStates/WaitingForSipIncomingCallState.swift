//
//  WaitingForSipIncomingCallState.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 16/11/22.
//

import Foundation

final class WaitingForSipIncomingCallState: BaseCallState, ICallState {
    init(callController: ICallController) {
        super.init(callController: callController, stateKey: .waitingForSipIncomingCall)
    }

    func onEnter(event _: CMEvent, session _: SessionData) {
        sendAppAction(appAction: AppAction(appActionType: .REMOTE_RINGING))
    }

    func onMessageReceived(event: CMEvent, session: SessionData) {
        switch event.eventType {
        case .SIP_INCOMING_CALL:
            guard let remoteUri = event.callIdentifier.remoteUri,
                  let localUri = event.localUri
            else {
                return sendEvent(event: CMEvent(eventType: .URI_MISSING_ERROR, callIdentifier: event.callIdentifier))
            }

            if localUri != session.uniqueUri {
                sendSipAction(sipAction: SipAction(sipActionType: .TOO_MANY_CALLS, remoteUri: remoteUri, uniqueUri: session.uniqueUri))
                sendEvent(event: CMEvent(eventType: .URI_MISMATCH, callIdentifier: event.callIdentifier))
                return
            }

            session.remoteUri = remoteUri
            sendSipAction(sipAction: SipAction(sipActionType: .SET_VIDEO_RECEIVER_VIEW, remoteUri: remoteUri, uniqueUri: session.uniqueUri, videoReceiverView: session.videoReceiverView))
            sendSipAction(sipAction: SipAction(sipActionType: .ANSWER, remoteUri: remoteUri, uniqueUri: session.uniqueUri))
        default:
            super.manageUnhandledMessageReceived(event: event, session: session)
        }
    }

    func onExit(event _: CMEvent, session _: SessionData) {}
}
