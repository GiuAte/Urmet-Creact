//
//  AppAction.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 09/11/22.
//

import Foundation

public enum AppActionType: Equatable {
    case CALL_STARTED
    case REMOTE_RINGING
    case LOCAL_RINGING
    case CALL_ACTIVE
    case CALL_ENDED
    case CALLEE_BUSY
    case CALLEE_UNREACHABLE
    case CALLEE_NOT_FOUND
    case CALLEE_UNKNOWN_TOPOLOGICAL
    case CALLEE_TIMED_OUT
    case CALLEE_REFUSED
    case SERVICE_UNAVAILABLE(reason: String)
    case TOO_MANY_CALLS
    case REQUEST_OUT_OF_CONTEXT
    case MICROPHONE_MUTED
    case MICROPHONE_UNMUTED
    case EARPIECE_AUDIO_OUTPUT
    case SPEAKER_AUDIO_OUTPUT
}

public struct AppAction {
    public let appActionType: AppActionType
}
