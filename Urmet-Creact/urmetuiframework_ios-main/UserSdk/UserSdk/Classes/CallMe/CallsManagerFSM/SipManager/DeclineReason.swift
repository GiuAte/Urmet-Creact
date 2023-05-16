//
//  DeclineReason.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 30/11/22.
//

import Foundation

enum DeclineReason {
    /// No reason
    case None
    /// The call was not answered in time (request timeout)
    case NotAnswered
    /// Phone line was busy
    case Busy
    /// Unsupported content
    case UnsupportedContent
    /// Do not disturb reason
    case DoNotDisturb
    /// Operation is unauthorized because missing credential
    case Unauthorized
    /// Operation is rejected due to incompatible or unsupported media parameters
    case NotAcceptable
    /// Resource moved permanently
    case MovedPermanently
    /// Resource no longer exists
    case Gone
    /// Temporarily unavailable
    case TemporarilyUnavailable
    /// Server timeout
    case ServerTimeout
    /// The call has been transferred
    case Transferred
}
