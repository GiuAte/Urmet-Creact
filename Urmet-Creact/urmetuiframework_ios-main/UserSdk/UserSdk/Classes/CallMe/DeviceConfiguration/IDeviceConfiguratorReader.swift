//
//  IDeviceConfiguratorReader.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 13/10/22.
//

import Foundation

public protocol IDeviceConfiguratorReader {
    typealias Result = Swift.Result<Configuration, Error>
    typealias Completion = (Result) -> Void

    func read(completion: @escaping Completion)
}
