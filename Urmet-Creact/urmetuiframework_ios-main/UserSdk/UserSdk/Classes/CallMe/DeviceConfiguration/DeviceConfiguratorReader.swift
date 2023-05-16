//
//  DeviceConfiguratorReader.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 13/10/22.
//

import Foundation

public final class DeviceConfiguratorReader: IDeviceConfiguratorReader {
    private let client: TCPClient

    init(client: TCPClient) {
        self.client = client
    }

    public enum Error: Swift.Error {
        case connection
        case read
        case invalidData
    }

    public func read(completion: @escaping Completion) {
        client.openConnection { [weak self] openConnectionError in
            guard openConnectionError == nil else {
                return completion(.failure(Error.connection))
            }
            self?.sendReadConfigurationCommand(completion: completion)
        }
    }

    private func sendReadConfigurationCommand(completion: @escaping Completion) {
        client.write(.readConfigurationPayload) { [weak self] writeError in
            guard let self = self else { return }

            guard writeError == nil else {
                self.client.closeConnection { _ in }
                return completion(.failure(Error.read))
            }
            self.readConfiguration(completion: completion)
        }
    }

    private func readConfiguration(completion: @escaping Completion) {
        client.read { [weak self] readResult in
            guard let self = self else { return }

            self.client.closeConnection { _ in }

            guard let data = try? readResult.get() else {
                return completion(.failure(Error.read))
            }
            completion(self.map(data))
        }
    }

    private func map(_ data: Data) -> IDeviceConfiguratorReader.Result {
        guard
            let response = try? JSONDecoder().decode(DeviceConfigurationPayload.self, from: data), response.action == 2,
            let configuration = makeConfiguration(response)
        else { return .failure(Error.invalidData) }

        return .success(configuration)
    }

    private func makeConfiguration(_ response: DeviceConfigurationPayload) -> Configuration? {
        guard let videoQuality = VideoQuality(rawValue: response.videoquality) else {
            return nil
        }

        return Configuration(
            ipConfiguration: makeIpConfiguration(from: response),
            name: response.name,
            alarm: response.alarm,
            timezone: response.timezone,
            networkInterface: makeNetworkInterface(from: response),
            sipConfiguration: makeSipConfiguration(from: response),
            videoQuality: videoQuality,
            wifiList: makeWifiList(from: response)
        )
    }

    private func makeIpConfiguration(from r: DeviceConfigurationPayload) -> IpConfiguration {
        return r.dhcp ? IpConfigurationDefault() : IpConfigurationAdvanced(ip: r.ip, subnetMask: r.mask, defaultGateway: r.gateway, dns: r.dns)
    }

    private func makeNetworkInterface(from r: DeviceConfigurationPayload) -> NetworkInterface {
        let wifiIntervalsConfiguration = makeWifiIntervalsConfiguration(from: r)
        return r.eth ? NetworkInterfaceWired() : NetworkInterfaceWireless(encryption: r.wifikey, password: r.wifipassword, ssid: r.wifissid, wifiIntervalsConfiguration: wifiIntervalsConfiguration)
    }

    private func makeWifiIntervalsConfiguration(from r: DeviceConfigurationPayload) -> WifiIntervalsConfiguration {
        return WifiIntervalsConfiguration(switchOffIntervals: r.nowifibeginlist, switchOnIntervals: r.nowifiendlist)
    }

    private func makeSipConfiguration(from r: DeviceConfigurationPayload) -> SipConfiguration {
        return SipConfiguration(username: r.login, password: r.password, server: r.sipserver, stun: r.stunserver)
    }

    private func makeWifiList(from r: DeviceConfigurationPayload) -> [Wifi] {
        return zip(r.wifissidlist, zip(r.wifiqualitylist, r.wifikeylist)).map { ssid, powerStringAndSecurity in
            let (powerString, security) = powerStringAndSecurity
            let power = Int(powerString) ?? 0
            return Wifi(ssid: ssid, power: power, security: security)
        }
    }
}

private extension Data {
    static var readConfigurationPayload: Data {
        return "{\"action\":0}".data(using: .isoLatin1)!
    }
}
