//
//  Camera.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 10/01/23.
//

import Foundation

public class Camera: Device {
    override init(name: String, type: DeviceType, ipercomAttributes: IpercomDeviceAttributes) {
        super.init(name: name, type: type, ipercomAttributes: ipercomAttributes)
    }

    init(device: Device) {
        super.init(name: device.name, type: device.type, ipercomAttributes: device.ipercomAttributes)
    }
}
