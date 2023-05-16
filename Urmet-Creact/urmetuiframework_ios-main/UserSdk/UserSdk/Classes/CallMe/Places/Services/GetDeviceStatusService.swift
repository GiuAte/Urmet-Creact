//
//  GetDeviceStatusService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 05/07/22.
//

import Foundation

final class GetDeviceStatusService {
    typealias Result = Swift.Result<DeviceStatus, Error>

    public enum Error: Swift.Error {
        case connectivity
        case unauthorized
        case invalidData
    }

    private struct ResponseRoot: Decodable {
        let data: DeviceStatus

        var deviceStatus: DeviceStatus {
            return data
        }
    }

    private let baseUrl: URL
    private let client: HTTPClient

    init(client: HTTPClient, baseUrl: URL) {
        self.baseUrl = baseUrl
        self.client = client
    }

    func get(statusForUID uid: String, completion: @escaping (Result) -> Void) {
        let url = baseUrl
            .appendingPathComponent("tool/callmeapi/private/get_device_status")
            .appendingPathComponent(uid)

        client.get(fromURL: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                completion(.failure(.connectivity))

            case let .success((data, httpResponse)):
                completion(self.map(data, and: httpResponse))
            }
        }
    }

    private func map(_ data: Data, and response: HTTPURLResponse) -> GetDeviceStatusService.Result {
        if response.statusCode == 401 {
            return .failure(.unauthorized)
        }

        guard
            response.statusCode == 200,
            let root = try? JSONDecoder().decode(ResponseRoot.self, from: data)
        else { return .failure(.invalidData) }

        return .success(root.deviceStatus)
    }
}
