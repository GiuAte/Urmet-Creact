//
//  HistoryViewModel.swift
//  CallMe
//
//  Created by Luca Lancellotti on 28/07/22.
//

import Foundation
import UIKit

class HistoryViewModel {
    var sections: [HistorySection] = [
        HistorySection(day: "OGGI", date: Date(timeIntervalSince1970: 1_652_344_445), items: [
            HistoryItem(time: "18:32", image: UIImage(named: "HistoryCam")!, name: "Casa ROSSI Casa ROSSI Casa ROSSI", description: "Principale 1", type: .camera, new: true),
            HistoryItem(time: "14:11", image: UIImage(named: "HistoryCam")!, name: "Casa al mare", description: "Secondario 1", new: true),
            HistoryItem(time: "9:56", image: UIImage(named: "HistoryNoCam")!, name: "Ufficio no cam", description: "Principale 1", new: true),
            HistoryItem(time: "4:23", image: UIImage(named: "HistoryAlarm")!, name: "Casa ROSSI", description: "Antipanico", type: .phone, alarm: true),
        ]),
        HistorySection(day: "IERI", date: Date(timeIntervalSince1970: 1_652_258_045), items: [
            HistoryItem(time: "20:15", image: UIImage(named: "HistoryCondo")!, name: "Casa ROSSI", description: "Apt. 35", type: .phone),
        ]),
    ]

    var filter: HistoryFilter = .all

    var collectionSections: [HistorySection] {
        switch filter {
        case .alarms:
            return sections.map { section -> HistorySection in
                let section = section.copy() as! HistorySection
                section.items = section.items.filter { $0.alarm == true }
                return section
            }.filter { $0.items.count > 0 }
        case .all:
            return sections
        }
    }
}

enum HistoryFilter {
    case alarms
    case all
}
