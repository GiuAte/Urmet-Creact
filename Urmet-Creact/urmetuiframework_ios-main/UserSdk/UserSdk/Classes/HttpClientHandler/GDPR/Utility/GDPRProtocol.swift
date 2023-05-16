//
//  GDPRProtocol.swift
//  CallMeSdk
//
//  Created by Silvio Fosso on 25/01/23.
//

import Foundation
public protocol IGDPRProtocol: AnyObject {
    func success(model: [GDPRModel])
    func error(error: Error)
}
