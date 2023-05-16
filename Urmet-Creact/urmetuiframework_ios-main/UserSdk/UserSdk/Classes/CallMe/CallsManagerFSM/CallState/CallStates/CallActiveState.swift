//
//  CallActiveState.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 14/11/22.
//

import Foundation

final class CallActiveState: BaseCallState, ICallState {
    init(callController: ICallController) {
        super.init(callController: callController, stateKey: .callActive)
    }

    func onEnter(event _: CMEvent, session _: SessionData) {
        sendAppAction(appAction: AppAction(appActionType: .CALL_ACTIVE))
    }

    func onMessageReceived(event: CMEvent, session: SessionData) {
        switch event.eventType {
        case .ON_HOOK:
            guard let remoteUri = session.remoteUri else {
                return sendEvent(event: CMEvent(eventType: .URI_MISSING_ERROR, callIdentifier: event.callIdentifier))
            }

            sendSipAction(sipAction: SipAction(sipActionType: .TERMINATE_CALL, remoteUri: remoteUri, uniqueUri: session.uniqueUri))
        case let .REQUEST_IN_CALL_ACTION(toneAction: action):
            guard let remoteUri = session.remoteUri else {
                return sendEvent(event: CMEvent(eventType: .URI_MISSING_ERROR, callIdentifier: event.callIdentifier))
            }

            sendSipAction(sipAction: SipAction(sipActionType: .EXECUTE_IN_CALL_ACTION(toneAction: action), remoteUri: remoteUri, uniqueUri: session.uniqueUri))
        case .REQUEST_TOGGLE_MUTE:
            guard let remoteUri = session.remoteUri else {
                return sendEvent(event: CMEvent(eventType: .URI_MISSING_ERROR, callIdentifier: event.callIdentifier))
            }

            sendSipAction(sipAction: SipAction(sipActionType: .TOGGLE_MUTE, remoteUri: remoteUri, uniqueUri: session.uniqueUri))
        case .SIP_MICROPHONE_MUTED:
            sendAppAction(appAction: AppAction(appActionType: .MICROPHONE_MUTED))
        case .SIP_MICROPHONE_UNMUTED:
            sendAppAction(appAction: AppAction(appActionType: .MICROPHONE_UNMUTED))
        case .REQUEST_AUDIO_ROUTE_SPEAKER:
            guard let remoteUri = session.remoteUri else {
                return sendEvent(event: CMEvent(eventType: .URI_MISSING_ERROR, callIdentifier: event.callIdentifier))
            }

            sendSipAction(sipAction: SipAction(sipActionType: .ROUTE_TO_SPEAKER, remoteUri: remoteUri, uniqueUri: session.uniqueUri))
        case .REQUEST_AUDIO_ROUTE_EARPIECE:
            guard let remoteUri = session.remoteUri else {
                return sendEvent(event: CMEvent(eventType: .URI_MISSING_ERROR, callIdentifier: event.callIdentifier))
            }

            sendSipAction(sipAction: SipAction(sipActionType: .ROUTE_TO_EARPIECE, remoteUri: remoteUri, uniqueUri: session.uniqueUri))
        case .SIP_SPEAKER_OUTPUT:
            sendAppAction(appAction: AppAction(appActionType: .SPEAKER_AUDIO_OUTPUT))
        case .SIP_EARPIECE_OUTPUT:
            sendAppAction(appAction: AppAction(appActionType: .EARPIECE_AUDIO_OUTPUT))
        default:
            super.manageUnhandledMessageReceived(event: event, session: session)
        }
    }

    func onExit(event _: CMEvent, session _: SessionData) {}
}
