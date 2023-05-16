//
//  FlagsHandler.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 28/03/22.
//

import Foundation

struct DeviceFlags: Equatable {
    public let MainPowerSupplyDown: Bool
    public let JoinOnlyByToken: Bool
    public let JoinDisabled: Bool
}

class FlagsHandler {
    private var flags: UInt64

    public init(flags: UInt64) {
        self.flags = flags
    }

    private func modifyBit(flags: UInt64, position: Int, value: Bool) -> UInt64 {
        let setMode: UInt64 = value == true ? 1 : 0
        let mask: UInt64 = 1 << position
        return ((flags & ~mask) | (setMode << position))
    }

    private func isMainPowerSupplyDown() -> Bool {
        return (flags & 1 << 0 != 0) ? true : false
    }

    public func setMainPowerSupply(down: Bool) {
        flags = modifyBit(flags: flags, position: 0, value: down)
    }

    private func isJoinOnlyByToken() -> Bool {
        return (flags & 1 << 1 != 0) ? true : false
    }

    private func isJoinDisabled() -> Bool {
        return (flags & 1 << 2 != 0) ? true : false
    }

    public func getFlags() -> UInt64 {
        return flags
    }

    public func getDeviceFlags() -> DeviceFlags {
        return DeviceFlags(
            MainPowerSupplyDown: isMainPowerSupplyDown(),
            JoinOnlyByToken: isJoinOnlyByToken(),
            JoinDisabled: isJoinDisabled()
        )
    }
}
