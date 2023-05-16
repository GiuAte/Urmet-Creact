//
//  DeviceConfigurator.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 30/09/22.
//

import Foundation

public typealias IDeviceConfigurator = IDeviceConfiguratorReader & IDeviceConfiguratorWriter

public final class DeviceConfigurator: IDeviceConfigurator {
    private let reader: IDeviceConfiguratorReader
    private let writer: IDeviceConfiguratorWriter

    public init(reader: IDeviceConfiguratorReader, writer: IDeviceConfiguratorWriter) {
        self.reader = reader
        self.writer = writer
    }

    public func write(_ configuration: Configuration, completion: @escaping IDeviceConfiguratorWriter.Completion) {
        writer.write(configuration, completion: completion)
    }

    public func read(completion: @escaping IDeviceConfiguratorReader.Completion) {
        reader.read(completion: completion)
    }
}
