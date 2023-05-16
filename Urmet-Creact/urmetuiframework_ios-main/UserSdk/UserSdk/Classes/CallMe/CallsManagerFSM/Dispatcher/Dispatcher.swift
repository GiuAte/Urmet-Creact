//
//  Dispatcher.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 08/11/22.
//

import Foundation

class Dispatcher {
    func dispatch(event: CMEvent, callControllers: [CallController]) -> DispatchResponse {
        if let sipUri = event.callIdentifier.remoteUri,
           event.eventType == .SIP_INCOMING_CALL
        {
            let dispatched = dispatchIncomingCall(uri: sipUri, callControllers: callControllers)
            if !dispatched {
                return .tooManyCalls
            }
        }

        var handled = false
        callControllers.forEach { callController in
            handled = handled || callController.insertEvent(event: event)
        }

        return handled ? .handle : .cannotHandle
    }

    private func dispatchIncomingCall(uri: String, callControllers: [CallController]) -> Bool {
        for callController in callControllers {
            if callController.setSipIdentifier(sipUri: uri) {
                return true
            }
        }
        return false
    }
}
