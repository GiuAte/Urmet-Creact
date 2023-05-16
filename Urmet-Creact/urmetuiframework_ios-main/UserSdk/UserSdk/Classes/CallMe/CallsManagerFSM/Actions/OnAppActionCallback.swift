//
//  AppActionCompletion.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 09/11/22.
//

import Foundation

public typealias AppActionCompletion = (AppAction) -> Void

public struct OnAppActionCallback: Equatable {
    let callbackId: UUID
    let completion: AppActionCompletion

    public init(completion: @escaping AppActionCompletion) {
        callbackId = UUID()
        self.completion = completion
    }

    public static func == (lhs: OnAppActionCallback, rhs: OnAppActionCallback) -> Bool {
        return lhs.callbackId == rhs.callbackId
    }
}
