//
//  GDPRStatementToUpload.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 17/06/22.
//

import Foundation

public enum GDPRStatementSelectionStatus: Int {
    case accepted = 1
    case rejected = -1
    case noChoice = 0
}

public struct GDPRStatementToUpload: Encodable {
    private let STM_ID: String
    private let is_applyed: String

    public var id: String { return STM_ID }
    public var status: GDPRStatementSelectionStatus { return GDPRStatementSelectionStatus(rawValue: Int(is_applyed)!)! }

    public init(id: String, selected: GDPRStatementSelectionStatus) {
        STM_ID = id
        is_applyed = String(selected.rawValue)
    }
}
