//
//  AppMessage.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 08/11/22.
//

import Foundation
import UIKit

struct AppMessage {
    let eventType: CMEventType
    let callControllerId: UUID
    var calleeInfo: CalleeInfo? = nil
    weak var videoReceiverView: UIView? = nil
}
