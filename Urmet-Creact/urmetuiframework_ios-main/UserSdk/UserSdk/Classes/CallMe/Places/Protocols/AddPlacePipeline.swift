//
//  AddPlacePipeline.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 05/07/22.
//

import Foundation

protocol AddPlacePipeline {
    typealias Result = AddPlacePipelineError?

    func add(fromQR qr: String, completion: @escaping (Result) -> Void)
}
