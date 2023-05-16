//
//  GenericInternalPlace.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 22/06/22.
//

import Foundation

struct GenericInternalPlace: InternalPlace, Decodable {
    let type: PlaceType
    let uid: String
    let mac: String
    let channelNumberString: String
    let relationName: String
    let sharingPermission: String
    let incCredentialUsername: String
    let incCredentialPassword: String
    let outCredentialUsername: String
    let outCredentialPassword: String
    let flags: UInt64?

    var isSharable: Bool {
        return sharingPermission == "1"
    }

    var id: String {
        if uid != "" {
            return "\(uid)-\(channelNumber)"
        }
        return "\(mac)-\(channelNumber)"
    }

    var channelNumber: Int {
        return Int(channelNumberString)!
    }

    private enum CodingKeys: String, CodingKey {
        case type = "uid_type"
        case uid = "device_uid"
        case mac = "Mac_Address"
        case channelNumberString = "channel_number"
        case relationName = "relation_name"
        case sharingPermission = "sharing_permissions"
        case incCredentialUsername = "channel_id"
        case incCredentialPassword = "credentials"
        case outCredentialUsername = "out_credentials_username"
        case outCredentialPassword = "out_credentials_password"
        case flags
    }
}
