//
//  IAccountRegistrationManager.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 15/11/22.
//

import Foundation

protocol IAccountRegistrationManager {
    typealias Completion = () -> Void

    func sync(completion: @escaping Completion)
}
