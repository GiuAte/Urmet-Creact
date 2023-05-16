//
//  Place.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 20/06/22.
//

import Foundation

public struct Place {
    public let id: String
    public internal(set) var name: String
    public let capabilities: [PlaceCapability]
    public let family: PlaceFamilyType
    public let model: PlaceType
    public internal(set) var enabled: Bool
    let accounts: [Account]
    var ipercomGatewayUri: String?
    let mac: String?
    let uid: String?
    let strategies: [PlaceStrategy]

    init(
        id: String,
        uid: String?,
        name: String,
        capabilities: [PlaceCapability],
        accounts: [Account],
        ipercomGatewayUri: String?,
        mac: String?,
        family: PlaceFamilyType,
        model: PlaceType,
        strategies: [PlaceStrategy],
        enabled: Bool
    ) {
        self.id = id
        self.uid = uid
        self.name = name
        self.capabilities = capabilities
        self.accounts = accounts
        self.ipercomGatewayUri = ipercomGatewayUri
        self.mac = mac
        self.family = family
        self.model = model
        self.strategies = strategies
        self.enabled = enabled
    }
}
