//
//  SharingQRCode.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 26/07/22.
//

import Foundation

struct SharingQRCode: Encodable {
    let destination: Int
    let model: String
    let token: String
    let from: String
    let role: String

    enum CodingKeys: String, CodingKey {
        case destination = "d"
        case model = "m"
        case token
        case from
        case role
    }
}
