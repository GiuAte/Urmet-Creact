//
//  HTTPClient.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 15/06/22.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    typealias Headers = [String: String]

    func post(toURL url: URL, withHeaders headers: Headers, andBody body: Data, completion: @escaping (HTTPClient.Result) -> Void)
    func put(toURL url: URL, withHeaders headers: Headers, andBody body: Data, completion: @escaping (HTTPClient.Result) -> Void)
    func get(fromURL url: URL, completion: @escaping (HTTPClient.Result) -> Void)
    func delete(atURL url: URL, completion: @escaping (HTTPClient.Result) -> Void)
}
