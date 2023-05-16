//
//  AccountLoader.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 18/10/22.
//

import Foundation

protocol AccountLoader {
    typealias LoadResult = Swift.Result<Bool, Error>
    typealias Completion = (LoadResult) -> Void

    func load(completion: @escaping Completion)
}
