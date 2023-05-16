//
//  CreateDeviceSipAccountService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/10/22.
//

import Foundation

class CreateDeviceSipAccountService: ICreateDeviceSipAccountService {
    private let createSipAccountService: ICreateSipAccountService
    private let realm: String

    enum Error: Swift.Error {
        case invalidQR
        case genericError
        case connectivity
        case unauthorized
        case invalidData
    }

    init(createSipAccountService: ICreateSipAccountService, realm: String) {
        self.createSipAccountService = createSipAccountService
        self.realm = realm
    }

    func registerSipAccount(withQRCode qrCode: String, completion: @escaping ICreateDeviceSipAccountService.Completion) {
        guard let macAddress = parseMac(fromQr: qrCode) else {
            return completion(.failure(CreateDeviceSipAccountService.Error.invalidQR))
        }

        let username = MacToCredentials.getUsername(mac: macAddress)
        let password = MacToCredentials.getPassword(mac: macAddress)
        createSipAccountService.create(accountWithUsername: username, andPassword: password, forRealm: realm, completion: { result in
            switch result {
            case .success:
                completion(.success(true))
            case let .failure(err as CreateSipAccountService.Error):
                completion(.failure(self.map(err)))
            case .failure:
                completion(.failure(CreateDeviceSipAccountService.Error.genericError))
            }
        })
    }

    private func map(_ error: CreateSipAccountService.Error) -> CreateDeviceSipAccountService.Error {
        switch error {
        case .connectivity:
            return CreateDeviceSipAccountService.Error.connectivity
        case .unauthorized:
            return CreateDeviceSipAccountService.Error.unauthorized
        case .invalidData:
            return CreateDeviceSipAccountService.Error.invalidData
        }
    }

    private func parseMac(fromQr qrCode: String) -> String? {
        let type = ConfigurationQRCodeTypeMapper.getType(qrCode)

        switch type {
        case .Mac:
            return extractMac(fromQR: qrCode)
        case .Json:
            return try? JSONDecoder().decode(ConfigurationQRModel.self, from: qrCode.data(using: .utf8)!).M
        default:
            return nil
        }
    }

    private func extractMac(fromQR qrCode: String) -> String? {
        let pattern = "(([a-fA-F0-9]{2}){6})"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: qrCode.count)

        let matches = regex.matches(in: qrCode, options: [], range: range).first
        let macFound = matches.map { match in
            let range = Range(match.range, in: qrCode)!
            return String(qrCode[range])
        }
        return macFound
    }

    private struct ConfigurationQRModel: Decodable {
        let M: String /// MAC Address
    }
}
