//
//  RingingState.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 09/12/22.
//

import Foundation

final class RingingState: BaseCallState, ICallState {
    init(callController: ICallController) {
        super.init(callController: callController, stateKey: .ringing)
    }

    func onEnter(event _: CMEvent, session _: SessionData) {
        sendAppAction(appAction: AppAction(appActionType: .LOCAL_RINGING))
    }

    func onMessageReceived(event: CMEvent, session: SessionData) {
        switch event.eventType {
        case .OFF_HOOK:
            if let remoteUri = session.remoteUri {
                sendSipAction(sipAction: SipAction(sipActionType: .SET_VIDEO_RECEIVER_VIEW, remoteUri: remoteUri, uniqueUri: session.uniqueUri, videoReceiverView: session.videoReceiverView))
                sendSipAction(sipAction: SipAction(sipActionType: .ANSWER, remoteUri: remoteUri, uniqueUri: session.uniqueUri))
            }
        case .ON_HOOK:
            if let remoteUri = session.remoteUri {
                sendSipAction(sipAction: SipAction(sipActionType: .DECLINE_CALL_BUSY, remoteUri: remoteUri, uniqueUri: session.uniqueUri))
            }
        case .ACTIVATE_EARLY_MEDIA:
            if let remoteUri = session.remoteUri {
                sendSipAction(sipAction: SipAction(sipActionType: .SET_VIDEO_RECEIVER_VIEW, remoteUri: remoteUri, uniqueUri: session.uniqueUri, videoReceiverView: session.videoReceiverView))
                sendSipAction(sipAction: SipAction(sipActionType: .ACCEPT_EARLY_MEDIA, remoteUri: remoteUri, uniqueUri: session.uniqueUri))
            }
        default:
            super.manageUnhandledMessageReceived(event: event, session: session)
        }
    }

    func onExit(event _: CMEvent, session _: SessionData) {}
}
