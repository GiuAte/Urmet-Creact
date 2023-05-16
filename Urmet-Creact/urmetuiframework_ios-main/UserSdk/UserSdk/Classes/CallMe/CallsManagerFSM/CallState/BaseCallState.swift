//
//  BaseCallState.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 07/11/22.
//

import Foundation

class BaseCallState {
    private var stateKey: StateKey
    private var callController: ICallController

    init(callController: ICallController, stateKey: StateKey) {
        self.callController = callController
        self.stateKey = stateKey
    }

    func sendEvent(event: CMEvent) {
        _ = callController.insertEvent(event: event)
    }

    func sendSipAction(sipAction: SipAction) {
        callController.manageSipAction(sipAction: sipAction)
    }

    func sendAppAction(appAction: AppAction) {
        callController.manageAppAction(appAction: appAction)
    }

    func clearSipIdentifier() {
        callController.clearSipIdentifier()
    }

    func manageUnhandledMessageReceived(event: CMEvent, session: SessionData) {
        switch event.eventType {
        case .CONFIGURE_VIDEO_RECEIVER_VIEW:
            session.videoReceiverView = event.videoReceiverView
        default:
            if event.source == .App {
                sendAppAction(appAction: AppAction(appActionType: .REQUEST_OUT_OF_CONTEXT))
            }
            Sdk.logger.warning(message: "Unhandled message not recognised: \(event)")
        }
    }
}
