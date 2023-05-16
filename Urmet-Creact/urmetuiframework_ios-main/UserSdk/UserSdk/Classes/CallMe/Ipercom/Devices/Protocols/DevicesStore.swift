//
//  DevicesStore.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/12/22.
//

import Foundation

protocol DevicesStore {
    typealias CamerasResult = Swift.Result<[Camera], Error>
    typealias ContactsResult = Swift.Result<[Contact], Error>
    typealias RetrieveCamerasCompletion = (CamerasResult) -> Void
    typealias RetrieveContactsCompletion = (ContactsResult) -> Void
    typealias InsertCompletion = (Error?) -> Void
    typealias DeleteCompletion = (Error?) -> Void

    func retrieveCameras(forPlace place: Place, completion: @escaping RetrieveCamerasCompletion)
    func retrieveContacts(forPlace place: Place, completion: @escaping RetrieveContactsCompletion)
    func insert(_ devices: [Device], forPlace place: Place, completion: @escaping InsertCompletion)
    func delete(forPlace place: Place, completion: @escaping InsertCompletion)
    func clear(completion: @escaping DeleteCompletion)
}
