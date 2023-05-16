//
//  CallController.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 08/11/22.
//

import Foundation

class CallController: ICallController {
    private var eventQueue: SynchronizedFIFOQueue<CMEvent>
    private var stateMachine: CallStateMachine?
    private var callsManager: ICallsManager
    private var callIdentifier: CallIdentifier

    private var isCheckingQueue = AtomicBoolean()

    init(callsManager: ICallsManager, callControllerId: UUID, uniqueUri: String) {
        eventQueue = SynchronizedFIFOQueue()
        self.callsManager = callsManager
        callIdentifier = CallIdentifier(callControllerId: callControllerId)
        stateMachine = CallStateMachine(callController: self, uniqueUri: uniqueUri)
    }

    func getSessionId() -> UUID {
        return callIdentifier.callControllerId!
    }

    func setSipIdentifier(sipUri: String) -> Bool {
        guard callIdentifier.remoteUri == nil else {
            return false
        }

        callIdentifier.remoteUri = sipUri
        return true
    }

    func clearSipIdentifier() {
        callIdentifier.remoteUri = nil
    }

    func manageSipAction(sipAction: SipAction) {
        callsManager.manageSipAction(sipAction: sipAction)
    }

    func manageAppAction(appAction: AppAction) {
        callsManager.manageAppAction(callControllerId: getSessionId(), appAction: appAction)
    }

    func insertEvent(event: CMEvent) -> Bool {
        if event.callIdentifier == callIdentifier {
            eventQueue.insert(event)
            DispatchQueue.global().async { [weak self] in
                guard let self else { return }
                if !self.isCheckingQueue.getAndSet(true) {
                    self.checkQueue()
                }
            }
            return true
        }
        callsManager.insertEvent(event)
        return false
    }

    private func checkQueue() {
        if eventQueue.isEmpty {
            isCheckingQueue.set(false)
        } else {
            if let event = eventQueue.remove() {
                manageEvent(event: event)
            }
        }
    }

    private func manageEvent(event: CMEvent) {
        guard let stateMachine else {
            return
        }

        stateMachine.onEvent(event: event)

        checkQueue()
    }
}
