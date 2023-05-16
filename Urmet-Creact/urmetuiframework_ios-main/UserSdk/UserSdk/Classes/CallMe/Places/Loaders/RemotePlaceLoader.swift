//
//  PlaceService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 20/06/22.
//

import Foundation

class RemotePlaceLoader: PlaceLoader {
    public enum Error: Swift.Error {
        case unauthorized
        case connectivity
        case invalidData
    }

    private let baseUrl: URL
    private let client: HTTPClient
    private let realm: String
    private let ipercomGetGatewayService: IIpercomGetGatewayService

    public init(baseUrl: URL, client: HTTPClient, realm: String, ipercomGetGatewayService: IIpercomGetGatewayService) {
        self.baseUrl = baseUrl
        self.client = client
        self.realm = realm
        self.ipercomGetGatewayService = ipercomGetGatewayService
    }

    public func get(completion: @escaping Completion) {
        let url = URL(string: "\(baseUrl)/tool/callmeapi/private/get_my_devices")!
        client.get(fromURL: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success((data, response)):
                switch RemotePlaceMapper.map(data, response, self.realm) {
                case let .success(places):
                    self.getIpercomGateway(places: places, completion: completion)
                case let .failure(error):
                    completion(.failure(error))
                }

            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }

    private func getIpercomGateway(places: [Place], completion: @escaping Completion) {
        var mutablePlaces = places
        let group = DispatchGroup()
        for (idx, place) in mutablePlaces.enumerated() {
            if place.family == .Ipercom {
                group.enter()
                ipercomGetGatewayService.getGateway(for: place) { result in
                    switch result {
                    case let .success(gateway):
                        mutablePlaces[idx].ipercomGatewayUri = gateway
                    default:
                        // TODO: valutare se restituire errore nel caso in cui non si riesca a completare il place con l'ipercomGatewayUri
                        break
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            completion(.success(mutablePlaces))
        }
    }

    func update(completion: @escaping Completion) {
        get(completion: completion)
    }
}
