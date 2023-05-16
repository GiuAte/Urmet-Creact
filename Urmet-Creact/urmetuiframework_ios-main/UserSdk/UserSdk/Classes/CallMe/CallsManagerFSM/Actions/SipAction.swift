//
//  SipAction.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 09/11/22.
//

import Foundation
import UIKit

enum SipActionType: Equatable {
    case CALL_DEVICE_REQ
    case CANCEL_CALL_REQ
    case TOO_MANY_CALLS
    case ERROR
    case ANSWER
    case TERMINATE_CALL
    case DECLINE_CALL_BUSY
    case SET_VIDEO_RECEIVER_VIEW
    case ACCEPT_EARLY_MEDIA
    case EXECUTE_IN_CALL_ACTION(toneAction: InCallToneAction)
    case TOGGLE_MUTE
    case ROUTE_TO_SPEAKER
    case ROUTE_TO_EARPIECE
}

struct SipAction {
    let sipActionType: SipActionType
    let calleeInfo: CalleeInfo?
    let callIdentifier: CallIdentifier
    let uniqueUri: String
    weak var videoReceiverView: UIView?

    init(sipActionType: SipActionType, remoteUri: String, uniqueUri: String, videoReceiverView: UIView? = nil) {
        self.sipActionType = sipActionType
        callIdentifier = CallIdentifier(remoteUri: remoteUri)
        calleeInfo = nil
        self.uniqueUri = uniqueUri
        self.videoReceiverView = videoReceiverView
    }

    init(sipActionType: SipActionType, calleeInfo: CalleeInfo, callIdentifier: CallIdentifier, uniqueUri: String) {
        self.sipActionType = sipActionType
        self.callIdentifier = callIdentifier
        self.calleeInfo = calleeInfo
        self.uniqueUri = uniqueUri
        videoReceiverView = nil
    }
}
