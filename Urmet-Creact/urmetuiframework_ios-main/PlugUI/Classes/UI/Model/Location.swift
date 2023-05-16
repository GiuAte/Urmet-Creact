//
//  Location.swift
//  CallMe
//
//  Created by Luca Lancellotti on 28/07/22.
//

import Foundation
import UIKit

var defaultLocations = [
    Location(name: "Casa Rossi", enabled: false, entrances: [
        "Ingresso principale 1",
        "Ingresso principale 2",
        "Ingresso secondario 1",
    ], activables: [
        Location.Activable(name: "Esterno", on: true),
        Location.Activable(name: "Interno", on: false),
        Location.Activable(name: "Esterno", on: false),
        Location.Activable(name: "Interno", on: false),
        Location.Activable(name: "Esterno Esterno", on: false),
        Location.Activable(name: "Interno", on: false),
        Location.Activable(name: "Esterno", on: false),
    ], contacts: [
        Contact(name: "Appartamento 1", image: UIImage(named: "IconApartment")!),
        Contact(name: "Appartamento 2", image: UIImage(named: "IconApartment")!),
        Contact(name: "Appartamento 3", image: UIImage(named: "IconApartment")!),
        Contact(name: "Appartamento 4", image: UIImage(named: "IconApartment")!),
        Contact(name: "Appartamento 5", image: UIImage(named: "IconApartment")!),
        Contact(name: "Appartamento 6", image: UIImage(named: "IconApartment")!),
        Contact(name: "Appartamento 7", image: UIImage(named: "IconApartment")!),
        Contact(name: "Appartamento 8", image: UIImage(named: "IconApartment")!),
        Contact(name: "Appartamento 9", image: UIImage(named: "IconApartment")!),
        Contact(name: "Appartamento 10 con testo molto lungo per vedere come va a capo", image: UIImage(named: "IconApartment")!),
    ], users: [
        User(name: "Marco", surname: "Aranacione"),
        User(name: "Elena", surname: "Giallo"),
        User(name: "Gianfilippo", surname: "Rossi"),
        User(name: "Elena", surname: "Bianchi"),
    ]),
    Location(name: "Casa al mare", enabled: true, oldModel: true, entrances: [
        "Ingresso mare 1",
        "Ingresso principale 2",
        "Ingresso secondario 1",
    ], activables: [], contacts: [
        Contact(name: "Rossi", image: UIImage(named: "IconApartment")!),
        Contact(name: "Roberti", image: UIImage(named: "IconApartment")!),
        Contact(name: "Rovagnati", image: UIImage(named: "IconApartment")!),
    ], users: [
        User(name: "Marco", surname: "Aranacione"),
        User(name: "Elena", surname: "Giallo"),
    ]),
]

class Location: Equatable {
    var name: String
    var enabled: Bool
    var license: Bool
    var oldModel: Bool
    var entrances: [String]
    var activables: [Activable]
    var contacts: [Contact]
    var users: [User]

    init(name: String, enabled: Bool, license: Bool = true, oldModel: Bool = false, entrances: [String], activables: [Activable], contacts: [Contact] = [], users: [User] = []) {
        self.name = name
        self.enabled = enabled
        self.license = license
        self.oldModel = oldModel
        self.entrances = entrances
        self.activables = activables
        self.contacts = contacts
        self.users = users
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.name == rhs.name &&
            lhs.enabled == rhs.enabled &&
            lhs.oldModel == rhs.oldModel &&
            lhs.entrances == rhs.entrances &&
            lhs.activables == rhs.activables
    }

    class Activable: Equatable {
        var name: String
        var on: Bool

        init(name: String, on: Bool) {
            self.name = name
            self.on = on
        }

        static func == (lhs: Location.Activable, rhs: Location.Activable) -> Bool {
            return lhs.name == rhs.name &&
                lhs.on == rhs.on
        }
    }
}
