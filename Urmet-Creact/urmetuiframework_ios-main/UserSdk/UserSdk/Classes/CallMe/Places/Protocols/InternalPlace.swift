//
//  InternalPlace.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 20/06/22.
//

import Foundation

protocol InternalPlace {
    var id: String { get }
    var type: PlaceType { get }
    var uid: String { get }
    var mac: String { get }
    var channelNumber: Int { get }
    var relationName: String { get }
    var isSharable: Bool { get }
    var incCredentialUsername: String { get }
    var incCredentialPassword: String { get }
    var outCredentialUsername: String { get }
    var outCredentialPassword: String { get }
    var flags: UInt64? { get }
}
