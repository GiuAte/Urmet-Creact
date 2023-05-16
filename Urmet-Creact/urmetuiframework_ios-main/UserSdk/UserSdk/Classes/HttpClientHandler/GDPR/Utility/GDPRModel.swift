//
//  GDPRModel.swift
//  CallMeSdk
//
//  Created by Silvio Fosso on 25/01/23.
//

import Foundation
public struct GDPRModel {
    public let id: String
    public let title: String
    public let content: String
    public let url: String
    public let mandatory: String
    public var status: GDPRStatementSelectionStatus
}
