//
//  IMissedCallsSaver.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 27/12/22.
//

import Foundation

protocol IMissedCallsSaver {
    typealias InsertCompletion = (Error?) -> Void

    func insert(_ missedCalls: [MissedCall], forPlace place: Place, completion: @escaping InsertCompletion)
}
