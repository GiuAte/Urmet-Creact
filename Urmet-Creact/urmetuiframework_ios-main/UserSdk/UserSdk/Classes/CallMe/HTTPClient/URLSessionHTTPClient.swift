//
//  URLSessionHTTPClient.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 16/06/22.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func post(toURL url: URL, withHeaders headers: Headers, andBody body: Data, completion: @escaping (HTTPClient.Result) -> Void) {
        let request = makeURLRequest(url: url, httpMethod: "POST", headers: headers, body: body)
        execute(session, withRequest: request, completion: completion)
    }

    public func put(toURL url: URL, withHeaders headers: Headers, andBody body: Data, completion: @escaping (HTTPClient.Result) -> Void) {
        let request = makeURLRequest(url: url, httpMethod: "PUT", headers: headers, body: body)
        execute(session, withRequest: request, completion: completion)
    }

    public func get(fromURL url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        let request = makeURLRequest(url: url, httpMethod: "GET")
        execute(session, withRequest: request, completion: completion)
    }

    public func delete(atURL url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        let request = makeURLRequest(url: url, httpMethod: "DELETE")
        execute(session, withRequest: request, completion: completion)
    }

    // MARK: - Helpers

    private func makeURLRequest(url: URL, httpMethod: String, headers: Headers = [:], body: Data = Data()) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = body
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

    private func map(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> HTTPClient.Result {
        if let data = data, let httpResponse = response as? HTTPURLResponse {
            return .success((data, httpResponse))
        } else if let error = error {
            return .failure(error)
        } else {
            return .failure(NSError(domain: "URLSessionHTTPClient", code: -1))
        }
    }

    private func execute(_ session: URLSession, withRequest request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            completion(self.map(data, response, error))
        }.resume()
    }
}
