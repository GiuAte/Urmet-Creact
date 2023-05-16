//
//  GDPRStatementStatus.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 28/09/22.
//

import Foundation

public struct GDPRStatementStatus: Decodable, Hashable {
    private let STM_ID: String
    private let is_applyed: String

    public var id: String { return STM_ID }
    public var status: GDPRStatementSelectionStatus { return GDPRStatementSelectionStatus(rawValue: Int(is_applyed)!)! }

    init(STM_ID: String, is_applyed: String) {
        self.STM_ID = STM_ID
        self.is_applyed = is_applyed
    }
}
