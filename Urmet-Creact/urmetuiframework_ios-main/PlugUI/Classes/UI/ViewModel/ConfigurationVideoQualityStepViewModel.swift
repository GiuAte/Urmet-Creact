//
//  AddLocationConfigurationThirdStepViewModel.swift
//  CallMe
//
//  Created by Luca Lancellotti on 04/08/22.
//

import Foundation

class ConfigurationVideoQualityStepViewModel {
    var qualities = [
        QualityConfiguration(name: "Bassa", description: "Velocità < 300 Kbit/sec"),
        QualityConfiguration(name: "Media", description: "Velocità < 1 Mbit/sec"),
        QualityConfiguration(name: "Alta", description: "Velocità > 300 Kbit/sec"),
    ]
}
