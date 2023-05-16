//
//  CallsManager.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 07/11/22.
//

import Foundation

class CallsManager: ICallsManager {
    private var dispatcher: Dispatcher
    private var callControllers: [CallController] = []
    private var sipCallback: OnSipActionCallback?
    private var appCallbacks: [UUID: [OnAppActionCallback]] = [:]
    private var eventQueue: SynchronizedFIFOQueue<CMEvent>
    private var uniqueUri: String

    init(maxControllers: Int, uniqueUri: String) {
        dispatcher = Dispatcher()
        eventQueue = SynchronizedFIFOQueue()
        self.uniqueUri = uniqueUri
        (0 ... maxControllers - 1).forEach { _ in
            let callControllerId = UUID()
            let callController = CallController(callsManager: self, callControllerId: callControllerId, uniqueUri: uniqueUri)
            callControllers.append(callController)
        }
    }

    func insertEvent(_ event: CMEvent) {
        eventQueue.insert(event)
        checkQueue()
    }

    private func checkQueue() {
        if !eventQueue.isEmpty {
            if let event = eventQueue.remove() {
                manageEvent(event)
                checkQueue()
            }
        }
    }

    private func manageEvent(_ event: CMEvent) {
        let dispatchResponse = dispatcher.dispatch(event: event, callControllers: callControllers)
        manageDispatchResponse(dispatchResponse, forEvent: event)
    }

    private func manageDispatchResponse(_ response: DispatchResponse, forEvent event: CMEvent) {
        switch response {
        case .handle:
            break
        case .cannotHandle:
            if let sipUri = event.callIdentifier.remoteUri,
               let sipCallback
            {
                sipCallback(SipAction(sipActionType: .ERROR, remoteUri: sipUri, uniqueUri: uniqueUri))
            }
            if let callControllerId = event.callIdentifier.callControllerId,
               let appCallbacks = appCallbacks[callControllerId]
            {
                appCallbacks.forEach {
                    $0.completion(AppAction(appActionType: .REQUEST_OUT_OF_CONTEXT))
                }
            }
        case .tooManyCalls:
            if let sipUri = event.callIdentifier.remoteUri,
               let sipCallback
            {
                sipCallback(SipAction(sipActionType: .TOO_MANY_CALLS, remoteUri: sipUri, uniqueUri: uniqueUri))
            }
            if let callControllerId = event.callIdentifier.callControllerId,
               let appCallbacks = appCallbacks[callControllerId]
            {
                appCallbacks.forEach {
                    $0.completion(AppAction(appActionType: .TOO_MANY_CALLS))
                }
            }
        }
    }

    // MARK: SipAction Management

    func manageSipAction(sipAction: SipAction) {
        if let sipCallback {
            sipCallback(sipAction)
        }
    }

    func addSipActionCallback(callback: @escaping OnSipActionCallback) {
        sipCallback = callback
    }

    // MARK: AppAction Management

    func register() -> UUID? {
        for callController in callControllers {
            let callControllerId = callController.getSessionId()
            if !appCallbacks.keys.contains(callControllerId) {
                appCallbacks[callControllerId] = []
                return callControllerId
            }
        }
        return nil
    }

    func unregister(callControllerId: UUID) {
        appCallbacks.removeValue(forKey: callControllerId)
    }

    func addAppActionCallback(callControllerId: UUID, callback: OnAppActionCallback) {
        appCallbacks[callControllerId]?.append(callback)
    }

    func removeAppActionCallback(callControllerId: UUID, callback: OnAppActionCallback) {
        appCallbacks[callControllerId]?.removeAll(where: { $0 == callback })
    }

    func manageAppAction(callControllerId: UUID, appAction: AppAction) {
        if let sessionCallbacks = appCallbacks[callControllerId] {
            sessionCallbacks.forEach {
                $0.completion(appAction)
            }
        }
    }
}
