//
//  Transaction.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 08/11/22.
//

import Foundation

struct Transaction {
    var from: StateKey
    var event: CMEvent
    var to: StateKey
}
