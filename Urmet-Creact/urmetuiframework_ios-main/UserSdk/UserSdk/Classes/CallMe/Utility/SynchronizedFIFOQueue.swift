//
//  SynchronizedFIFOQueue.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 15/11/22.
//

import Foundation

class SynchronizedFIFOQueue<T>: FIFOQueue<T> {
    private let serialQueue = DispatchQueue(label: String(describing: SynchronizedFIFOQueue.self))

    override var isEmpty: Bool {
        return serialQueue.sync {
            super.isEmpty
        }
    }

    override var peek: T? {
        return serialQueue.sync {
            super.peek
        }
    }

    override func insert(_ element: T) {
        serialQueue.sync {
            super.insert(element)
        }
    }

    override func remove() -> T? {
        return serialQueue.sync {
            super.remove()
        }
    }
}
