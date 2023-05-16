//
//  LocalAlarmsSaver.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 27/12/22.
//

import Foundation

class LocalAlarmsSaver: IAlarmsSaver {
    private let store: AlarmsStore

    init(store: AlarmsStore) {
        self.store = store
    }

    enum Error: Swift.Error {
        case insertError
    }

    func insert(_ alarms: [Alarm], forPlace place: Place, completion: @escaping InsertCompletion) {
        store.delete(forPlace: place) { [weak self] error in
            guard let self else { return }

            guard error == nil else {
                return completion(Error.insertError)
            }

            self.store.insert(alarms, forPlace: place) { error in
                guard error == nil else {
                    return completion(Error.insertError)
                }

                completion(nil)
            }
        }
    }
}
