//
//  SessionData.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 07/11/22.
//

import Foundation
import UIKit

class SessionData {
    let uniqueUri: String
    var localUri: String?
    var remoteUri: String?
    var sessionId: UUID = .init()
    var calleeInfo: CalleeInfo?
    weak var videoReceiverView: UIView?

    init(uniqueUri: String, localUri: String? = nil, remoteUri: String? = nil, calleeInfo: CalleeInfo? = nil, videoReceiverView: UIView? = nil) {
        self.uniqueUri = uniqueUri
        self.localUri = localUri
        self.remoteUri = remoteUri
        self.calleeInfo = calleeInfo
        self.videoReceiverView = videoReceiverView
    }

    func cleanUp() {
        localUri = nil
        remoteUri = nil
        sessionId = UUID()
        calleeInfo = nil
        // TODO: think about not clearing videoReceiverView, the users set it once and can call multiple times without setting it every time
        videoReceiverView = nil
    }
}
