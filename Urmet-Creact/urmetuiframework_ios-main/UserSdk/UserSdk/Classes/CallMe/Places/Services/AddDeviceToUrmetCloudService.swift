//
//  AddDeviceToUrmetCloudService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 04/07/22.
//

import Foundation

final class AddDeviceToUrmetCloudService {
    typealias Result = Swift.Result<VirtualDevice, Error>

    public enum Error: Swift.Error {
        case connectivity
        case unauthorized
        case invalidData
    }

    private struct ResponseRoot: Decodable {
        let data: VirtualDevice

        var virtualDevice: VirtualDevice {
            return data
        }
    }

    private let client: HTTPClient
    private let baseUrl: URL

    init(client: HTTPClient, baseUrl: URL) {
        self.client = client
        self.baseUrl = baseUrl
    }

    private struct Request: Encodable {
        let uid: String
        let model: String
        let set_ownership: Bool
    }

    func add(deviceWithUID uid: String, andModel model: String, setOwnership: Bool, completion: @escaping (Result) -> Void) {
        let url = baseUrl.appendingPathComponent("tool/callmeapi/private/add_device_2UC/")

        let request = Request(uid: uid, model: model, set_ownership: setOwnership)
        let requestBody = try! JSONEncoder().encode(request)

        client.put(toURL: url, withHeaders: [:], andBody: requestBody) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                return completion(.failure(.connectivity))

            case let .success((data, httpResponse)):
                return completion(self.map(data, and: httpResponse))
            }
        }
    }

    private func map(_ data: Data, and response: HTTPURLResponse) -> AddDeviceToUrmetCloudService.Result {
        if response.statusCode == 401 {
            return .failure(.unauthorized)
        }

        guard
            response.statusCode == 200,
            let root = try? JSONDecoder().decode(ResponseRoot.self, from: data)
        else { return .failure(.invalidData) }

        return .success(root.virtualDevice)
    }
}
