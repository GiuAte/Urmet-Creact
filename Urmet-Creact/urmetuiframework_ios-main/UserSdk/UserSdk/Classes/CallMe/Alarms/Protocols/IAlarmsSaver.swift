//
//  IAlarmsSaver.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 27/12/22.
//

import Foundation

protocol IAlarmsSaver {
    typealias InsertCompletion = (Error?) -> Void

    func insert(_ alarms: [Alarm], forPlace place: Place, completion: @escaping InsertCompletion)
}
