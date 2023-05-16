//
//  QualityConfiguration.swift
//  CallMe
//
//  Created by Luca Lancellotti on 04/08/22.
//

import Foundation

class QualityConfiguration {
    var name: String
    var description: String
    var selected = false

    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}
