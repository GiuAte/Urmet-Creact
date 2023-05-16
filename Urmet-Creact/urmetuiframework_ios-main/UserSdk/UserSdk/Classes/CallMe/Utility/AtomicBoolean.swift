//
//  AtomicBoolean.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 15/11/22.
//

import Foundation

class AtomicBoolean {
    private let serialQueue = DispatchQueue(label: String(describing: AtomicBoolean.self))
    private var value: Bool = false

    func get() -> Bool {
        return serialQueue.sync {
            value
        }
    }

    func getAndSet(_ newValue: Bool) -> Bool {
        return serialQueue.sync {
            let oldValue = value
            value = newValue
            return oldValue
        }
    }

    func set(_ newValue: Bool) {
        return serialQueue.sync {
            value = newValue
        }
    }
}
