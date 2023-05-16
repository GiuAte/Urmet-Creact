//
//  IContactsLoader.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/12/22.
//

import Foundation

protocol IContactsLoader {
    typealias Result = Swift.Result<[Contact], Error>
    typealias Completion = (Result) -> Void

    func get(forPlace place: Place, completion: @escaping Completion)
    func update(forPlace place: Place, completion: @escaping Completion)
}
