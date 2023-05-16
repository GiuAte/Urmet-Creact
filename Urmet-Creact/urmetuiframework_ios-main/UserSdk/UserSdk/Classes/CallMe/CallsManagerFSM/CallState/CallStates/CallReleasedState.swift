//
//  CallReleasedState.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 14/11/22.
//

import Foundation

final class CallReleasedState: BaseCallState, ICallState {
    init(callController: ICallController) {
        super.init(callController: callController, stateKey: .callReleased)
    }

    func onEnter(event: CMEvent, session _: SessionData) {
        sendAppAction(appAction: AppAction(appActionType: .CALL_ENDED))
        sendEvent(event: CMEvent(eventType: .IDLING, callIdentifier: event.callIdentifier))
    }

    func onMessageReceived(event: CMEvent, session: SessionData) {
        super.manageUnhandledMessageReceived(event: event, session: session)
    }

    func onExit(event _: CMEvent, session _: SessionData) {}
}
