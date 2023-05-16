//
//  TransactionManager.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 08/11/22.
//

import Foundation

class TransactionManager {
    private var transactions: [Transaction]

    init() {
        transactions = [
            Transaction(from: .idle, event: CMEvent(eventType: .BEGIN_CALL_ME_BACK), to: .callMeBack),
            Transaction(from: .idle, event: CMEvent(eventType: .CALLEEINFO_MISSING_ERROR), to: .callError),
            Transaction(from: .idle, event: CMEvent(eventType: .URI_MISSING_ERROR), to: .callError),
            Transaction(from: .idle, event: CMEvent(eventType: .SIP_INCOMING_CALL), to: .ringing),

            Transaction(from: .ringing, event: CMEvent(eventType: .SIP_CONNECTED), to: .callActive),
            Transaction(from: .ringing, event: CMEvent(eventType: .SIP_CALL_RELEASED), to: .callReleased),

            Transaction(from: .callMeBack, event: CMEvent(eventType: .SIP_CONNECTED), to: .callActive),
            Transaction(from: .callMeBack, event: CMEvent(eventType: .ON_HOOK), to: .localTerminatingCall),
            Transaction(from: .callMeBack, event: CMEvent(eventType: .MESSAGE_ERROR), to: .callError),
            Transaction(from: .callMeBack, event: CMEvent(eventType: .URI_MISSING_ERROR), to: .callError),
            Transaction(from: .callMeBack, event: CMEvent(eventType: .CALL_DEVICE_RES_SUCCESS), to: .waitingForSipIncomingCall),
            Transaction(from: .callMeBack, event: CMEvent(eventType: .CALL_DEVICE_RES_BUSY), to: .callReleased),
            Transaction(from: .callMeBack, event: CMEvent(eventType: .CALL_DEVICE_RES_REFUSED), to: .callReleased),
            Transaction(from: .callMeBack, event: CMEvent(eventType: .CALL_DEVICE_RES_TIMED_OUT), to: .callReleased),
            Transaction(from: .callMeBack, event: CMEvent(eventType: .CALL_DEVICE_RES_UNREACHABLE), to: .callReleased),
            Transaction(from: .callMeBack, event: CMEvent(eventType: .CALL_DEVICE_RES_DEVICE_NOT_FOUND), to: .callReleased),
            Transaction(from: .callMeBack, event: CMEvent(eventType: .CALL_DEVICE_RES_UNKNOWN_TOPOLOGICAL), to: .callReleased),
            Transaction(from: .callMeBack, event: CMEvent(eventType: .URI_MISMATCH), to: .callReleased),

            Transaction(from: .waitingForSipIncomingCall, event: CMEvent(eventType: .SIP_CONNECTED), to: .callActive),
            Transaction(from: .waitingForSipIncomingCall, event: CMEvent(eventType: .URI_MISSING_ERROR), to: .callError),
            Transaction(from: .waitingForSipIncomingCall, event: CMEvent(eventType: .ON_HOOK), to: .localTerminatingCall),
            Transaction(from: .waitingForSipIncomingCall, event: CMEvent(eventType: .URI_MISMATCH), to: .callReleased),

            Transaction(from: .callActive, event: CMEvent(eventType: .SIP_CALL_RELEASED), to: .callReleased),

            Transaction(from: .localTerminatingCall, event: CMEvent(eventType: .MESSAGE_ERROR), to: .callError),
            Transaction(from: .localTerminatingCall, event: CMEvent(eventType: .CALLEEINFO_MISSING_ERROR), to: .callError),
            Transaction(from: .localTerminatingCall, event: CMEvent(eventType: .CANCEL_CALL_RES_SUCCESS), to: .callReleased),

            Transaction(from: .callError, event: CMEvent(eventType: .SIP_CALL_RELEASED), to: .callReleased),

            Transaction(from: .callReleased, event: CMEvent(eventType: .IDLING), to: .idle),
        ]
    }

    func evaluate(from: StateKey, event: CMEvent) -> StateKey {
        for transaction in transactions {
            if transaction.from == from &&
                transaction.event.eventType == event.eventType
            {
                return transaction.to
            }
        }
        return from
    }
}
