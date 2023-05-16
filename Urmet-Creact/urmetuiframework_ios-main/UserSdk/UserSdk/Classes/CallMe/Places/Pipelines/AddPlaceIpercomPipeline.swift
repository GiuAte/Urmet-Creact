//
//  AddPlaceIpercomPipeline.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 06/07/22.
//

import Foundation

final class AddPlaceIpercomPipeline: AddPlacePipeline {
    enum Error: Swift.Error {
        case invalidQR
        case connectivity
        case unauthorized
        case invalidData
    }

    private struct QRCode: Decodable {
        let d: Int
        let ch: Int
        let n: String
        let par: Int
        let s: String
        let u: String
    }

    private let addDevice2UCService: AddDeviceToUrmetCloudService
    private let addChannelsToDeviceService: AddChannelsToDeviceService
    private let setMasterSharingService: SetMasterSharingService

    init(client: HTTPClient, baseUrl: URL) {
        addDevice2UCService = AddDeviceToUrmetCloudService(client: client, baseUrl: baseUrl)
        addChannelsToDeviceService = AddChannelsToDeviceService(client: client, baseURL: baseUrl)
        setMasterSharingService = SetMasterSharingService(client: client, baseUrl: baseUrl)
    }

    func add(fromQR qr: String, completion: @escaping (AddPlacePipeline.Result) -> Void) {
        guard let qrData = decodeQR(qr: qr) else { return completion(.invalidQR) }

        if QRParVerifier.isExpired(par: qrData.par) {
            return completion(.expiredQR)
        }

        addDevice2UCService.add(deviceWithUID: qrData.u, andModel: qrData.s, setOwnership: false) { [weak self] result in
            guard let self = self else { return completion(.connectivity) }
            switch result {
            case let .success(newDevice):
                self.addChannels(qrData: qrData, newDevice: newDevice, completion: completion)

            case let .failure(failure):
                completion(self.map(error: failure))
            }
        }
    }

    private func addChannels(qrData: QRCode, newDevice: VirtualDevice, completion: @escaping (AddPlacePipeline.Result) -> Void) {
        let channels = [-qrData.ch, 0, qrData.ch]

        addChannelsToDeviceService.add(channels: channels, toDeviceWithId: newDevice.id, model: qrData.s, ownership: false) { [weak self] addChannelResult in
            guard let self = self else { return completion(.connectivity) }
            switch addChannelResult {
            case .success:
                self.setMasterSharing(qrData: qrData, completion: completion)

            case let .failure(error):
                completion(self.map(error: error))
            }
        }
    }

    private func setMasterSharing(qrData: QRCode, completion: @escaping (AddPlacePipeline.Result) -> Void) {
        setMasterSharingService.set(withChannel: qrData.ch, deviceUID: qrData.u, relationName: qrData.n) { [weak self] setMasterSharingResult in
            guard let self = self else { return completion(.connectivity) }
            completion(self.map(result: setMasterSharingResult))
        }
    }

    private func decodeQR(qr: String) -> QRCode? {
        guard let decodedQR = try? JSONDecoder().decode(QRCode.self, from: qr.data(using: .utf8)!) else {
            return nil
        }
        return decodedQR
    }
}

extension AddPlaceIpercomPipeline {
    private func map(error: AddDeviceToUrmetCloudService.Error) -> AddPlacePipelineError {
        switch error {
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        }
    }

    private func map(error: AddChannelsToDeviceService.Error) -> AddPlacePipelineError {
        switch error {
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        }
    }

    private func map(result: SetMasterSharingService.Error?) -> AddPlacePipelineError? {
        switch result {
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        case .masterAlreadySet:
            return .masterAlreadySet
        case nil:
            return nil
        }
    }
}
