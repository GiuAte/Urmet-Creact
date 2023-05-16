//
//  AddPlacePipelineError.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 06/07/22.
//

import Foundation

enum AddPlacePipelineError: Swift.Error {
    case invalidQR
    case connectivity
    case unauthorized
    case invalidData
    case masterAlreadySet
    case expiredQR
}
