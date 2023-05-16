//
//  ContactsViewModel.swift
//  CallMe
//
//  Created by Luca Lancellotti on 01/08/22.
//

import Foundation

class ContactsViewModel {
    var search: String?

    var locations = defaultLocations

    var selectedLocation: Location?

    var contacts: [Contact] {
        guard let location = selectedLocation else {
            return []
        }
        if let search = search, !search.isEmpty {
            return location.contacts.filter { contact in
                contact.name.lowercased().contains(search.lowercased())
            }
        }
        return location.contacts
    }
}
