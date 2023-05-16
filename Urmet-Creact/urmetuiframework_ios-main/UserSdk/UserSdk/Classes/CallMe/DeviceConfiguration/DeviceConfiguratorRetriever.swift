//
//  DeviceConfiguratorRetriever.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 03/11/22.
//

import Foundation
import Network

public class DeviceConfiguratorRetriever: IDeviceConfiguratorRetriever {
    private let client: HTTPClient
    private let baseURL: URL
    private let realm: String
    private let accountStore: AccountStore

    public enum Error: Swift.Error {
        case typeAndQRCodeMismatch
        case invalidQR
        case connectivity
        case generic
        case unauthorized
        case invalidData
    }

    init(client: HTTPClient, baseURL: URL, realm: String, accountStore: AccountStore) {
        self.client = client
        self.baseURL = baseURL
        self.realm = realm
        self.accountStore = accountStore
    }

    public func getDeviceConfigurator(forType type: ConfigurableDeviceType, withQR qrCode: String, completion: @escaping Completion) {
        guard checkMatching(type: type, andQRCode: qrCode) else {
            return completion(.failure(DeviceConfiguratorRetriever.Error.typeAndQRCodeMismatch))
        }

        switch type {
        case .device58:
            completion(.success(getDeviceConfigurator58()))
        case .device58A:
            getDeviceConfigurator58A(withQR: qrCode, completion: completion)
        }
    }

    private func checkMatching(type: ConfigurableDeviceType, andQRCode qr: String) -> Bool {
        switch type {
        case .device58:
            return qr.isEmpty
        case .device58A:
            return ConfigurationQRCodeTypeMapper.getType(qr) == .Mac
        }
    }

    private func getDeviceConfigurator58() -> IDeviceConfigurator {
        let host = NWEndpoint.Host("192.168.50.1")
        let port = NWEndpoint.Port(4759)
        let options = NWProtocolTCP.Options()
        options.connectionTimeout = 2
        let params = NWParameters(tls: nil, tcp: options)
        let client = NWTCPClient(host: host, port: port, parameters: params)
        let reader = DeviceConfiguratorReader(client: client)
        let writer = DeviceConfiguratorWriter(client: client, accountStore: accountStore)
        let configurator = DeviceConfigurator(reader: reader, writer: writer)

        return configurator
    }

    private func getDeviceConfigurator58A(withQR qrCode: String, completion: @escaping IDeviceConfiguratorRetriever.Completion) {
        let createSipAccountService = CreateSipAccountService(client: client, baseURL: baseURL)
        let createDeviceSipAccountService = CreateDeviceSipAccountService(createSipAccountService: createSipAccountService, realm: realm)
        createDeviceSipAccountService.registerSipAccount(withQRCode: qrCode, completion: { result in
            switch result {
            case .success:
                let host = NWEndpoint.Host("192.168.50.1")
                let port = NWEndpoint.Port(4760)
                let options = NWProtocolTCP.Options()
                options.connectionTimeout = 2
                let params = NWParameters(tls: nil, tcp: options)
                let tcpClient = NWTCPClient(host: host, port: port, parameters: params)
                let crypto = UrmetCrypto()
                let client = TCPClientWithCryptoDecorator(client: tcpClient, crypto: crypto)
                let reader = DeviceConfiguratorReader(client: client)
                let writer = DeviceConfiguratorWriter(client: client, accountStore: self.accountStore)
                let configurator = DeviceConfigurator(reader: reader, writer: writer)
                completion(.success(configurator))
            case let .failure(err as CreateDeviceSipAccountService.Error):
                return completion(.failure(self.map(err)))
            case .failure:
                return completion(.failure(Error.generic))
            }
        })
    }

    private func map(_ error: CreateDeviceSipAccountService.Error) -> DeviceConfiguratorRetriever.Error {
        switch error {
        case .invalidQR:
            return DeviceConfiguratorRetriever.Error.invalidQR
        case .connectivity:
            return DeviceConfiguratorRetriever.Error.connectivity
        case .genericError:
            return DeviceConfiguratorRetriever.Error.generic
        case .unauthorized:
            return DeviceConfiguratorRetriever.Error.unauthorized
        case .invalidData:
            return DeviceConfiguratorRetriever.Error.invalidData
        }
    }
}
