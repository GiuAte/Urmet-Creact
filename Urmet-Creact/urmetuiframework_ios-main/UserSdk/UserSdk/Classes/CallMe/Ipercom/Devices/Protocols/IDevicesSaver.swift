//
//  IDevicesSaver.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/12/22.
//

import Foundation

protocol IDevicesSaver {
    typealias InsertCompletion = (Error?) -> Void
    typealias DeleteCompletion = (Error?) -> Void

    func insert(_ devices: [Device], forPlace place: Place, completion: @escaping InsertCompletion)
}
