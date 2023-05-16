//
//  CallMeBackState.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 14/11/22.
//

import Foundation

final class CallMeBackState: BaseCallState, ICallState {
    init(callController: ICallController) {
        super.init(callController: callController, stateKey: .callMeBack)
    }

    func onEnter(event: CMEvent, session: SessionData) {
        if let calleeInfo = session.calleeInfo {
            sendSipAction(sipAction: SipAction(sipActionType: .CALL_DEVICE_REQ, calleeInfo: calleeInfo, callIdentifier: event.callIdentifier, uniqueUri: session.uniqueUri))
        } else {
            sendEvent(event: CMEvent(eventType: .CALLEEINFO_MISSING_ERROR, callIdentifier: event.callIdentifier))
        }
        sendAppAction(appAction: AppAction(appActionType: .CALL_STARTED))
    }

    func onMessageReceived(event: CMEvent, session: SessionData) {
        switch event.eventType {
        case .CALL_DEVICE_RES_REFUSED:
            sendAppAction(appAction: AppAction(appActionType: .CALLEE_REFUSED))
        case .CALL_DEVICE_RES_UNKNOWN_TOPOLOGICAL:
            sendAppAction(appAction: AppAction(appActionType: .CALLEE_UNKNOWN_TOPOLOGICAL))
        case .CALL_DEVICE_RES_TIMED_OUT:
            sendAppAction(appAction: AppAction(appActionType: .CALLEE_TIMED_OUT))
        case .CALL_DEVICE_RES_BUSY:
            sendAppAction(appAction: AppAction(appActionType: .CALLEE_BUSY))
        case .CALL_DEVICE_RES_UNREACHABLE:
            sendAppAction(appAction: AppAction(appActionType: .CALLEE_UNREACHABLE))
        case .CALL_DEVICE_RES_DEVICE_NOT_FOUND:
            sendAppAction(appAction: AppAction(appActionType: .CALLEE_NOT_FOUND))
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
