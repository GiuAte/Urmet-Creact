//
//  ILoginProtocol.swift
//  CallMeSdk
//
//  Created by Silvio Fosso on 26/01/23.
//

import Foundation
public protocol ILoginProtocol: AnyObject {
    func success(isLogged value: Bool, session session: URLSessionHTTPClient)
    func error(error: Error)
}
