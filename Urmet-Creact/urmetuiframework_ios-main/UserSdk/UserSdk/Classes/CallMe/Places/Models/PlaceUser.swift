//
//  PlaceUser.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 22/07/22.
//

import Foundation

public struct PlaceUser: Codable, Hashable {
    public let name: String
    public let surname: String
    let relation_type: String
    let sharing_permissions: String
    let userid: String
    let channelId: String?

    init(
        name: String,
        surname: String,
        relationType: String,
        sharingPermission: Bool,
        userId: String,
        channelId: String
    ) {
        self.name = name
        self.surname = surname
        relation_type = relationType
        sharing_permissions = sharingPermission ? "1" : "0"
        userid = userId
        self.channelId = channelId
    }

    public var isOwner: Bool {
        return relation_type == "owner"
    }

    public var isSharable: Bool {
        return sharing_permissions == "1"
    }

    public var completeName: String {
        return "\(name) \(surname)"
    }
}
