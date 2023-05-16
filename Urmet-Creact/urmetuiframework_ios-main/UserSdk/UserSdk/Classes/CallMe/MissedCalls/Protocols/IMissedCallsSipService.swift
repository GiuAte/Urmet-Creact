//
//  IMissedCallsSipService.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 16/09/22.
//

import Foundation

protocol IMissedCallsSipService {
    typealias Result = Swift.Result<[MissedCall], Error>
    typealias Completion = (Result) -> Void

    func getMissedCalls(for place: Place, andReplyTo responseUri: String, completion: @escaping Completion)
}
