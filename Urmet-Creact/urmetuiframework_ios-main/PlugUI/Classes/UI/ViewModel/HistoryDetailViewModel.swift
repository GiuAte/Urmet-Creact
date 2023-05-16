//
//  HistoryDetailViewModel.swift
//  CallMe
//
//  Created by Luca Lancellotti on 19/12/22.
//

import Foundation

class HistoryDetailViewModel {
    let date: Date
    let item: HistoryItem

    init(date: Date, item: HistoryItem) {
        self.date = date
        self.item = item
    }
}
