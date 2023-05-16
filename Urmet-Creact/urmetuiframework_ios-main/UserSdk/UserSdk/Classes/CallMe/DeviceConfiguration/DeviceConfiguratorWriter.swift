//
//  DeviceConfiguratorWriter.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 13/10/22.
//

import Foundation

public final class DeviceConfiguratorWriter: IDeviceConfiguratorWriter {
    private let client: TCPClient
    private let accountStore: AccountStore

    init(client: TCPClient, accountStore: AccountStore) {
        self.client = client
        self.accountStore = accountStore
    }

    public enum Error: Swift.Error {
        case connection
        case write
        case cfwAccountNotFound
    }

    public func write(_ configuration: Configuration, completion: @escaping Completion) {
        accountStore.retrieve { result in
            switch result {
            case let .success(accounts):
                guard let currentSipAccount = accounts.filter({ $0.direction == .bidirectional }).first else {
                    fallthrough
                }
                // TODO: STUN server configuration
                let sipConfiguration = SipConfiguration(username: currentSipAccount.username,
                                                        password: currentSipAccount.password,
                                                        server: currentSipAccount.realm,
                                                        stun: "")
                self.write(configuration, andSipConfiguration: sipConfiguration, completion: completion)
            case .failure:
                return completion(DeviceConfiguratorWriter.Error.cfwAccountNotFound)
            }
        }
    }

    private func write(_ configuration: Configuration, andSipConfiguration sipConfiguration: SipConfiguration, completion: @escaping Completion) {
        let payload = makePayload(with: configuration, andSipConfiguration: sipConfiguration)
        let dataToSend = try! JSONEncoder().encode(deviceConfigurationPayload: payload)

        client.openConnection { [weak self] openConnectionError in
            guard openConnectionError == nil else {
                return completion(DeviceConfiguratorWriter.Error.connection)
            }

            self?.client.write(dataToSend) { writeError in
                self?.client.closeConnection { _ in }
                completion(writeError == nil ? nil : DeviceConfiguratorWriter.Error.write)
            }
        }
    }

    private func makePayload(with configuration: Configuration, andSipConfiguration sipConfiguration: SipConfiguration) -> DeviceConfigurationPayload {
        return DeviceConfigurationPayload(
            action: 1,
            dhcp: configuration.ipConfiguration.isDhcpEnabled(),
            dns: configuration.ipConfiguration.getDns(),
            eth: !configuration.networkInterface.isWireless(),
            gateway: configuration.ipConfiguration.getDefaultGateway(),
            ip: configuration.ipConfiguration.getIpAddress(),
            login: sipConfiguration.username,
            mask: configuration.ipConfiguration.getSubnetMask(),
            name: configuration.name,
            password: sipConfiguration.password,
            sipserver: sipConfiguration.server,
            stunserver: sipConfiguration.stun,
            videoquality: configuration.videoQuality.rawValue,
            wifissid: configuration.networkInterface.wifiSsid(),
            wifikey: configuration.networkInterface.wifiEncryption(),
            wifipassword: configuration.networkInterface.wifiPassword(),
            wifissidlist: [String](),
            wifikeylist: [String](),
            wifiqualitylist: [],
            nowifibeginlist: configuration.networkInterface.switchOffWifiIntervals(),
            nowifiendlist: configuration.networkInterface.switchOnWifiIntervals(),
            timezone: configuration.timezone,
            alarm: configuration.alarm,
            profileLowResolution: "qqvga",
            profileLowFrameRate: 12.0,
            profileLowKbps: 128,
            profileMediumResolution: "qvga",
            profileMediumFrameRate: 12.0,
            profileMediumKbps: 300,
            profileHighResolution: "qvga",
            profileHighFrameRate: 30.0,
            profileHighKbps: 1024
        )
    }
}
