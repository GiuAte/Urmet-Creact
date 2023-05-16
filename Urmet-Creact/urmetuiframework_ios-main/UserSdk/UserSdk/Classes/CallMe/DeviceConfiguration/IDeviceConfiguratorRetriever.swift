//
//  IDeviceConfiguratorRetriever.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 03/11/22.
//

import Foundation

public protocol IDeviceConfiguratorRetriever {
    typealias Result = Swift.Result<IDeviceConfigurator, Error>
    typealias Completion = (Result) -> Void

    func getDeviceConfigurator(forType type: ConfigurableDeviceType, withQR qrCode: String, completion: @escaping Completion)
}
