//
//  CallStateMachine.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 08/11/22.
//

import Foundation

class CallStateMachine {
    private var currentStateKey: StateKey
    private var session: SessionData
    private var transactionManager: TransactionManager
    private var statusMap: [StateKey: ICallState]
    private var callController: ICallController

    init(callController: ICallController, statusMap: [StateKey: ICallState]? = nil, uniqueUri: String) {
        currentStateKey = .idle
        session = SessionData(uniqueUri: uniqueUri)
        transactionManager = TransactionManager()
        self.callController = callController
        if let statusMap {
            self.statusMap = statusMap
        } else {
            self.statusMap = [
                .idle: IdleState(callController: callController),
                .callMeBack: CallMeBackState(callController: callController),
                .callActive: CallActiveState(callController: callController),
                .waitingForSipIncomingCall: WaitingForSipIncomingCallState(callController: callController),
                .localTerminatingCall: LocalTerminatingCallState(callController: callController),
                .callError: CallErrorState(callController: callController),
                .callReleased: CallReleasedState(callController: callController),
                .ringing: RingingState(callController: callController),
            ]
        }
    }

    func onEvent(event: CMEvent) {
        guard let currentState = statusMap[currentStateKey] else {
            return
        }
        currentState.onMessageReceived(event: event, session: session)

        let nextStateKey = transactionManager.evaluate(from: currentStateKey, event: event)
        if nextStateKey != currentStateKey,
           let nextState = statusMap[nextStateKey]
        {
            currentState.onExit(event: event, session: session)
            nextState.onEnter(event: event, session: session)
            currentStateKey = nextStateKey
        }
    }
}
