//
//  DeviceConfiguratorRetrieverWithAccountsService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 04/11/22.
//

import Foundation

class DeviceConfiguratorRetrieverWithAccountsService: IDeviceConfiguratorRetriever {
    private let deviceConfiguratorRetriever: IDeviceConfiguratorRetriever
    private let accountLoader: AccountLoader

    init(deviceConfiguratorRetriever: IDeviceConfiguratorRetriever, accountLoader: AccountLoader) {
        self.deviceConfiguratorRetriever = deviceConfiguratorRetriever
        self.accountLoader = accountLoader
    }

    func getDeviceConfigurator(forType type: ConfigurableDeviceType, withQR qrCode: String, completion: @escaping Completion) {
        accountLoader.load { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                self.deviceConfiguratorRetriever.getDeviceConfigurator(forType: type, withQR: qrCode, completion: completion)
            case let .failure(error as RemoteUserSipAccountLoader.Error):
                completion(.failure(self.map(error)))
            case .failure:
                completion(.failure(DeviceConfiguratorRetriever.Error.generic))
            }
        }
    }

    private func map(_ error: RemoteUserSipAccountLoader.Error) -> DeviceConfiguratorRetriever.Error {
        switch error {
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        }
    }
}
