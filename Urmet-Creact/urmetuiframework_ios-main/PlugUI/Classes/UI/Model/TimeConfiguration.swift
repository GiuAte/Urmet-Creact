//
//  TimeConfiguration.swift
//  CallMe
//
//  Created by Luca Lancellotti on 04/08/22.
//

import Foundation

class TimeConfiguration {
    var name: String
    var isExpanded = false
    var enabled = false
    var fromTime: String?
    var toTime: String?

    init(name: String) {
        self.name = name
    }
}
