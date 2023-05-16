//
//  IDeviceConfiguratorWriter.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 30/09/22.
//

import Foundation

public protocol IDeviceConfiguratorWriter {
    typealias Result = Error?
    typealias Completion = (Result) -> Void

    /// ⚠️⚠️⚠️ Calling this method will reboot the CallForwarding device upon completion.
    func write(_ configuration: Configuration, completion: @escaping Completion)
}
