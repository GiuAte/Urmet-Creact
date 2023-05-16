//
//  ServiceProvider.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 25/07/22.
//

import Foundation

public final class ServiceProvider {
    private let baseURL: URL
    private let client: HTTPClient
    private let origin: String

    public init(baseURL: URL, client: HTTPClient, origin: String) {
        self.baseURL = baseURL
        self.client = client
        self.origin = origin
    }
}
