//
//  ISipCallActionPerformer.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 29/11/22.
//

import Foundation
import UIKit

protocol ISipCallActionPerformer {
    func call(remoteUri: String)
    func decline(remoteUri: String, reason: DeclineReason)
    func accept(remoteUri: String)
    func terminate(remoteUri: String)
    func setVideoReceiverView(_ view: UIView, remoteUri: String)
    func acceptEarlyMedia(remoteUri: String)
    func sendDtmfs(_ dtmfs: String, remoteUri: String)
    func toggleMute(remoteUri: String) -> Bool?
    func setSpeakerOutput(remoteUri: String) -> Bool
    func setEarpieceOutput(remoteUri: String) -> Bool
}
