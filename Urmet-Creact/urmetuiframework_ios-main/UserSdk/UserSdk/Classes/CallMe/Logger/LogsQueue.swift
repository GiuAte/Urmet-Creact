//
//  LogsQueue.swift
//  CallMeSdk
//
//  Created by Niko on 03/01/23.
//

import Foundation

class LogsQueue<T>: FIFOQueue<T> {
    weak var delegate: (any LogsQueueDelegate)?
    private let serialQueue = DispatchQueue(label: String(describing: LogsQueue.self))

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
            delegate?.newLog()
        }
    }

    override func remove() -> T? {
        return serialQueue.sync {
            super.remove()
        }
    }
}

// MARK: Delegate Logs

protocol LogsQueueDelegate: AnyObject {
    func newLog()
}
