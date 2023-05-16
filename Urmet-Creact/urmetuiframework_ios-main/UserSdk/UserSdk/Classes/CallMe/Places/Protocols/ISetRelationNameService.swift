//
//  ISetRelationNameService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 27/09/22.
//

import Foundation

public protocol ISetRelationNameService {
    typealias Result = Swift.Result<Bool, Error>
    typealias Completion = (Result) -> Void

    func setRelationName(_ newName: String, forPlace place: Place, completion: @escaping Completion)
}
