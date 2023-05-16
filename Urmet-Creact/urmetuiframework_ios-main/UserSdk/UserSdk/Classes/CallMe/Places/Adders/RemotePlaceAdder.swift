//
//  RemotePlaceAdder.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/09/22.
//

import Foundation

class RemotePlaceAdder: PlaceAdder {
    enum Error: Swift.Error {
        case connectivity
        case generic
        case unauthorized
        case invalidQR
        case invalidData
        case masterAlreadySet
        case expiredQR
    }

    private let pipelines: [PlaceGroupType: AddPlacePipeline]
    private let placeLoader: PlaceLoader

    init(pipelines: [PlaceGroupType: AddPlacePipeline], placeLoader: PlaceLoader) {
        self.pipelines = pipelines
        self.placeLoader = placeLoader
    }

    func add(fromQRCode qr: String, completion: @escaping (AddResult) -> Void) {
        let placeGroupType = PlaceTypeGroupMapper.getType(qr)
        guard let pipeline = pipelines[placeGroupType] else { return completion(.failure(RemotePlaceAdder.Error.invalidQR)) }

        pipeline.add(fromQR: qr) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                return completion(.failure(self.map(error: error)))
            }

            guard let qrData = self.decodeQR(qr: qr) else { return completion(.success(nil)) }

            self.placeLoader.update { [weak self] result in
                guard let self = self else { return }

                switch result {
                case let .success(places):
                    return completion(.success(self.retrievePlace(places: places, uid: qrData.u, channelNumber: qrData.ch)))
                case .failure:
                    return completion(.success(nil))
                }
            }
        }
    }

    private func map(error: AddPlacePipelineError) -> RemotePlaceAdder.Error {
        switch error {
        case .invalidQR:
            return .invalidQR
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        case .masterAlreadySet:
            return .masterAlreadySet
        case .expiredQR:
            return .expiredQR
        }
    }

    func retrievePlace(places: [Place], uid: String, channelNumber: Int) -> Place? {
        return places.filter { $0.id == "\(uid)-\(channelNumber)" }.first
    }

    private struct QRCode: Decodable {
        let u: String /// UID
        let ch: Int /// ChannelNumber
    }

    private func decodeQR(qr: String) -> QRCode? {
        guard let decodedQR = try? JSONDecoder().decode(QRCode.self, from: qr.data(using: .utf8)!) else {
            return nil
        }

        return decodedQR
    }
}
