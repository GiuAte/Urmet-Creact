//
//  IPlaceService.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 19/09/22.
//

import Foundation

public protocol IPlaceService {
    typealias GetResult = Swift.Result<[Place], Error>
    typealias AddResult = Swift.Result<Place?, Error>
    typealias RemoveResult = Error?
    typealias EnableResult = Error?
    typealias DisableResult = Error?

    func get(completion: @escaping (GetResult) -> Void)
    func update(completion: @escaping (GetResult) -> Void)
    func add(fromQRCode qr: String, completion: @escaping (AddResult) -> Void)
    func remove(place: Place, completion: @escaping (RemoveResult) -> Void)
    func enable(place: Place, completion: @escaping (EnableResult) -> Void)
    func disable(place: Place, completion: @escaping (DisableResult) -> Void)
}
