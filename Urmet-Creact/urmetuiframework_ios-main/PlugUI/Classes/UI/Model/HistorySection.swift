//
//  HistorySection.swift
//  CallMe
//
//  Created by Luca Lancellotti on 28/07/22.
//

import Foundation

class HistorySection: NSCopying {
    var day: String
    var date: Date
    var items: [HistoryItem]

    init(day: String, date: Date, items: [HistoryItem]) {
        self.day = day
        self.date = date
        self.items = items
    }

    func copy(with _: NSZone? = nil) -> Any {
        let copy = HistorySection(day: day, date: date, items: items)

        return copy
    }
}
