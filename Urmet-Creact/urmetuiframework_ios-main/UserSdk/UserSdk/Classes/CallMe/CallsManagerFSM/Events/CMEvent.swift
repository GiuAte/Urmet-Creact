//
//  CMEvent.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 07/11/22.
//

import Foundation
import UIKit

enum EventSource {
    case App
    case Sip
    case System
}

struct CMEvent {
    let source: EventSource
    let eventType: CMEventType
    let callIdentifier: CallIdentifier
    var localUri: String?
    var calleeInfo: CalleeInfo?
    weak var videoReceiverView: UIView?

    init(_ sipMessage: SipMessage) {
        callIdentifier = sipMessage.callIdentifier
        localUri = sipMessage.localUri
        eventType = sipMessage.eventType
        source = .Sip
    }

    init(_ appMessage: AppMessage) {
        callIdentifier = CallIdentifier(callControllerId: appMessage.callControllerId)
        eventType = appMessage.eventType
        calleeInfo = appMessage.calleeInfo
        videoReceiverView = appMessage.videoReceiverView
        source = .App
    }

    init(eventType: CMEventType, callIdentifier: CallIdentifier = CallIdentifier()) {
        self.eventType = eventType
        self.callIdentifier = callIdentifier
        source = .System
    }
}
