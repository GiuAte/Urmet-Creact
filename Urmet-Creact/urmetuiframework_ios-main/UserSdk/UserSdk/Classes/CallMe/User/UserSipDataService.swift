//
//  UserSipDataService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 05/09/22.
//

import Foundation

final class UserSipDataService: IUserSipDataService {
    public enum Error: Swift.Error {
        case connectivity
        case unauthorized
        case invalidData
        case dataNotFound
    }

    private let client: HTTPClient
    private let baseURL: URL
    private let crypto: Crypto

    init(client: HTTPClient, baseURL: URL, crypto: Crypto = UrmetCrypto()) {
        self.client = client
        self.baseURL = baseURL
        self.crypto = crypto
    }

    private let requestAppID = "callme-sdk"
    private let requestKey = "sipdata"
    private lazy var requestUrl: URL = baseURL
        .appendingPathComponent("/tool/multiapi/private/userdata/")
        .appendingPathComponent(requestAppID)
        .appendingPathComponent(requestKey)

    // MARK: - get

    func get(completion: @escaping GetUserSipDataCompletion) {
        client.get(fromURL: requestUrl) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                completion(.failure(UserSipDataService.Error.connectivity))

            case let .success((data, httpResponse)):
                completion(self.map(data, httpResponse))
            }
        }
    }

    private func map(_ data: Data, _ httpResponse: HTTPURLResponse) -> GetUserSipDataResult {
        if httpResponse.statusCode == 401 {
            return .failure(UserSipDataService.Error.unauthorized)
        } else if httpResponse.statusCode == 404 {
            return .failure(UserSipDataService.Error.dataNotFound)
        } else if httpResponse.statusCode != 200 {
            return .failure(UserSipDataService.Error.invalidData)
        }

        guard let decodedData = Data(base64Encoded: data) else {
            return .failure(UserSipDataService.Error.invalidData)
        }
        let decryptedString: String = crypto.decrypt(decodedData)
        guard let resp = try? JSONDecoder().decode(UserSipData.self, from: decryptedString.data(using: .utf8)!) else {
            return .failure(UserSipDataService.Error.invalidData)
        }

        return .success(resp)
    }

    // MARK: - set

    func set(sipData: UserSipData, completion: @escaping SetUserSipDataCompletion) {
        guard
            let sipBlob = try? JSONEncoder().encode(sipData),
            let encryptedSipBlob = encryptBlob(sipBlob)
        else { return completion(.failure(UserSipDataService.Error.invalidData)) }

        let (boundary, body) = makeSetBody(encryptedSipBlob)
        guard let body else { return completion(.failure(UserSipDataService.Error.invalidData)) }

        client.post(
            toURL: requestUrl,
            withHeaders: ["Content-Type": "multipart/form-data; boundary=\(boundary)"],
            andBody: body
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case .failure:
                return completion(.failure(UserSipDataService.Error.connectivity))

            case let .success((data, httpResponse)):
                completion(self.map(data, httpResponse))
            }
        }
    }

    private func map(_: Data, _ httpResponse: HTTPURLResponse) -> SetUserSipDataResult {
        if httpResponse.statusCode == 401 {
            return .failure(UserSipDataService.Error.unauthorized)
        } else if httpResponse.statusCode != 200 {
            return .failure(UserSipDataService.Error.invalidData)
        }

        return .success(true)
    }

    private func encryptBlob(_ blob: Data) -> String? {
        guard
            let stringBlob = String(data: blob, encoding: .utf8)
        else { return nil }

        let encryptedBlob = crypto.encrypt(stringBlob)
        return encryptedBlob.base64EncodedString(options: .endLineWithCarriageReturn)
    }

    private func makeSetBody(_ blobString: String) -> (boundary: String, requestBody: Data?) {
        let boundary = "Boundary-\(UUID().uuidString)"

        var body = "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"data\"; filename=\"file.txt\"\r\n"
        body += "Content-Type: \"content-type header\"\r\n\r\n\(blobString)\r\n"
        body += "--\(boundary)--\r\n"

        return (boundary, body.data(using: .utf8))
    }
}
