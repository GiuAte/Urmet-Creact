//
//  AddPlaceTokenPipeline.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 05/07/22.
//

import Foundation

final class AddPlaceTokenPipeline: AddPlacePipeline {
    enum Error: Swift.Error {
        case invalidQR
        case connectivity
        case unauthorized
        case invalidData
    }

    private struct QRCode: Decodable {
        let d: Int
        let m: String
        let token: String
        let from: String
        let role: String
    }

    private let setNewSharingService: SetNewSharingService

    init(client: HTTPClient, baseUrl: URL) {
        setNewSharingService = SetNewSharingService(client: client, baseUrl: baseUrl)
    }

    func add(fromQR qr: String, completion: @escaping (AddPlacePipeline.Result) -> Void) {
        guard let qrData = decodeQR(qr: qr) else { return completion(.invalidQR) }

        setNewSharingService.set(newSharingFromToken: qrData.token) { [weak self] result in
            guard let self = self else { return }
            completion(self.map(result: result))
        }
    }

    private func decodeQR(qr: String) -> QRCode? {
        guard let decodedQR = try? JSONDecoder().decode(QRCode.self, from: qr.data(using: .utf8)!) else {
            return nil
        }

        return decodedQR
    }

    private func map(result: SetNewSharingService.Result) -> AddPlacePipelineError? {
        switch result {
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        case nil:
            return nil
        }
    }
}
