//
//  IRelationRemoverService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 07/10/22.
//

import Foundation

public protocol IRelationRemoverService {
    typealias Result = Error?

    func remove(deviceWithUID deviceId: String, andChannelId channelId: String, completion: @escaping (Result) -> Void)
}
