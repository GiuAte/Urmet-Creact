//
//  GDPRService.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 15/06/22.
//

import Foundation

public final class GDPRService: IGDPRService {
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    private let client: HTTPClient
    private let baseURL: URL
    private let origin: String

    init(client: HTTPClient, baseURL: URL, origin: String) {
        self.client = client
        self.baseURL = baseURL
        self.origin = origin
    }

    public func getStatements(completion: @escaping Completion) {
        let url = URL(string: "\(baseURL.absoluteString)/tool/webapi/public/get_gdpr_stm/")!
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let body = "origin=\(origin)".data(using: .utf8)!

        client.post(toURL: url, withHeaders: headers, andBody: body) {
            result in
            switch result {
            case let .success((data, httpResponse)):
                completion(self.map(data, and: httpResponse))

            case .failure:
                completion(.failure(GDPRService.Error.connectivity))
            }
        }
    }

    private func map(_ data: Data, and response: HTTPURLResponse) -> GDPRService.Result {
        guard
            response.statusCode == 200,
            let statements = try? JSONDecoder().decode([GDPRStatement].self, from: data)
        else {
            return .failure(GDPRService.Error.invalidData)
        }
        return .success(statements)
    }
}
