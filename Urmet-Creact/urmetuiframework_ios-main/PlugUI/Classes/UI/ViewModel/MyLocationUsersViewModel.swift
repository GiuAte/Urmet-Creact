//
//  MyLocationUsersViewModel.swift
//  CallMe
//
//  Created by Luca Lancellotti on 02/08/22.
//

import Foundation

class MyLocationUsersViewModel {
    var name: String
    var users: [User]

    init(location: Location) {
        name = location.name
        users = location.users
    }
}
