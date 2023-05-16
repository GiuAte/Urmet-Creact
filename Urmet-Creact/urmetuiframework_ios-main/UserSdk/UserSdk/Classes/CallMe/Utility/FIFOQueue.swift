//
//  FIFOQueue.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 08/11/22.
//

import Foundation

class FIFOQueue<T> {
    private var elements: [T] = []

    var isEmpty: Bool {
        return elements.isEmpty
    }

    var peek: T? {
        elements.first
    }

    func insert(_ element: T) {
        elements.append(element)
    }

    func remove() -> T? {
        elements.isEmpty ? nil : elements.removeFirst()
    }
}
