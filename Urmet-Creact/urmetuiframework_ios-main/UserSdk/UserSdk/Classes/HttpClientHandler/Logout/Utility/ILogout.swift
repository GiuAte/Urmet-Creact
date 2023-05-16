//
//  ILogout.swift
//  CallMeSdk
//
//  Created by Silvio Fosso on 27/01/23.
//

import Foundation
public protocol ILogout: AnyObject {
    func success(value: Bool)
    func error(value: Error)
}
