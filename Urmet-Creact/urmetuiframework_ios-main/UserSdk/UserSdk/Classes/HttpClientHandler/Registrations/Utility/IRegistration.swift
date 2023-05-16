//
//  RegistrationUtility.swift
//  CallMeSdk
//
//  Created by Silvio Fosso on 26/01/23.
//

import Foundation
public protocol IRegistration: AnyObject {
    func success(isSucceded value: Bool)
    func error(error value: Error)
}
