//
//  SetRelationNameService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 26/09/22.
//

import Foundation

public final class SetRelationNameService: ISetRelationNameService {
    public enum Error: Swift.Error {
        case invalidName
        case connectivity
        case unauthorized
        case invalidData
    }

    private struct Request: Encodable {
        let relation_name: String
    }

    private let baseUrl: URL
    private let client: HTTPClient
    private let path = "/tool/callmeapi/private/set_my_relation_name"

    init(baseUrl: URL, client: HTTPClient) {
        self.baseUrl = baseUrl
        self.client = client
    }

    public func setRelationName(_ newName: String, forPlace place: Place, completion: @escaping Completion) {
        if newName.isEmptyOrWhitespace {
            return completion(.failure(SetRelationNameService.Error.invalidName))
        }

        if let identifier = Place.extractSIPIncomingUsername(place: place) {
            setRelationName(newName, forPlaceIdentifier: identifier, completion: completion)
        } else {
            completion(.failure(SetRelationNameService.Error.invalidData))
        }
    }

    private func setRelationName(_ newName: String, forPlaceIdentifier identifier: String, completion: @escaping ISetRelationNameService.Completion) {
        let url = baseUrl
            .appendingPathComponent(path)
            .appendingPathComponent(identifier)
        let request = Request(relation_name: newName)
        let body = try! JSONEncoder().encode(request)

        client.post(toURL: url, withHeaders: [:], andBody: body) { result in
            switch result {
            case let .success((data, httpResponse)):
                completion(self.map(data: data, httpResponse: httpResponse))
            case .failure:
                completion(.failure(SetRelationNameService.Error.connectivity))
            }
        }
    }

    func map(data _: Data, httpResponse: HTTPURLResponse) -> ISetRelationNameService.Result {
        if httpResponse.statusCode == 401 {
            return .failure(SetRelationNameService.Error.unauthorized)
        } else if httpResponse.statusCode != 200 {
            return .failure(SetRelationNameService.Error.invalidData)
        }

        return .success(true)
    }
}
