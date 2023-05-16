//
//  NotificationCallViewModel.swift
//  CallMe
//
//  Created by Luca Lancellotti on 07/09/22.
//

import Foundation

class NotificationCallViewModel {
    var entrance = "Ingresso principale 1"

    var activables = [
        Location.Activable(name: "Esterno", on: true),
        Location.Activable(name: "Interno", on: false),
        /* Location.Activable(name: "Esterno", on: false),
            Location.Activable(name: "Interno", on: false),
            Location.Activable(name: "Esterno Esterno", on: false),
            Location.Activable(name: "Interno", on: false),
            Location.Activable(name: "Esterno", on: false) */
    ]
}
