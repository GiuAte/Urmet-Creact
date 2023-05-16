//
//  AddPlace1760_31Pipeline.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 30/09/22.
//

import Foundation

final class AddPlace1760_31Pipeline: AddPlacePipeline {
    enum Error: Swift.Error {
        case invalidQR
        case connectivity
        case unauthorized
        case invalidData
    }

    private struct QRCode: Decodable {
        let d: [Int] /// Destination
        let m: String /// Model
        let M: String /// MacAddress
        let u: String /// UID
        let ch: Int /// Channel
        let par: Int
        let cfw: Bool /// CallForwarder
        let lpe: Bool /// LowPowerEnabled

        private enum CodingKeys: String, CodingKey {
            case d
            case m
            case M
            case u
            case ch
            case par
            case cfw
            case lpe
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)

            // Handle if qr has int or [int] as destination
            do {
                let intDestination = try values.decode(Int.self, forKey: .d)
                d = [intDestination]
            } catch {
                d = try values.decode([Int].self, forKey: .d)
            }

            m = try values.decode(String.self, forKey: .m)
            M = try values.decode(String.self, forKey: .M)
            u = try values.decode(String.self, forKey: .u)
            ch = try values.decode(Int.self, forKey: .ch)
            par = try values.decode(Int.self, forKey: .par)
            cfw = try values.decode(Bool.self, forKey: .cfw)
            lpe = try values.decode(Bool.self, forKey: .lpe)
        }
    }

    private let getDeviceStatusService: GetDeviceStatusService
    private let setMasterSharingService: SetMasterSharingService
    private let getChannelFlagsService: GetChannelFlagsService
    private let setChannelFlagsService: SetChannelFlagsService

    init(client: HTTPClient, baseUrl: URL) {
        getDeviceStatusService = GetDeviceStatusService(client: client, baseUrl: baseUrl)
        setMasterSharingService = SetMasterSharingService(client: client, baseUrl: baseUrl)
        getChannelFlagsService = GetChannelFlagsService(client: client, baseUrl: baseUrl)
        setChannelFlagsService = SetChannelFlagsService(client: client, baseUrl: baseUrl)
    }

    func add(fromQR qr: String, completion: @escaping (AddPlacePipeline.Result) -> Void) {
        guard let qrData = decodeQR(qr: qr) else { return completion(.invalidQR) }

        if QRParVerifier.isExpired(par: qrData.par) {
            return completion(.expiredQR)
        }

        getDeviceStatusService.get(statusForUID: qrData.u) { [weak self] getDeviceStatusResult in
            guard let self = self else { return completion(.connectivity) }

            switch getDeviceStatusResult {
            case let .success(deviceStatus):
                self.setMasterSharingService.set(withChannel: qrData.ch, deviceUID: qrData.u, relationName: deviceStatus.installation_name) { [weak self] setMasterSharingResult in
                    guard let self = self else { return completion(.connectivity) }
                    if setMasterSharingResult != nil {
                        completion(self.map(error: setMasterSharingResult))
                    } else {
                        self.getChannelFlags(qrData: qrData, completion: completion)
                    }
                }

            case let .failure(error):
                completion(self.map(error: error))
            }
        }
    }

    private func decodeQR(qr: String) -> QRCode? {
        guard let decodedQR = try? JSONDecoder().decode(QRCode.self, from: qr.data(using: .utf8)!) else {
            return nil
        }
        return decodedQR
    }

    private func getChannelFlags(qrData: QRCode, completion: @escaping (AddPlacePipeline.Result) -> Void) {
        getChannelFlagsService.get(forUID: qrData.u, andChannel: qrData.ch) { [weak self] result in
            guard let self = self else { return completion(.connectivity) }
            switch result {
            case let .failure(error):
                completion(self.map(error: error))

            case let .success(channelFlags):
                self.alignChannelFlags(qrData: qrData, cloudFlags: channelFlags, completion: completion)
            }
        }
    }

    private func alignChannelFlags(qrData: QRCode, cloudFlags: ChannelFlags, completion: @escaping (AddPlacePipeline.Result) -> Void) {
        let cloudFlagsHandler = FlagsHandler(flags: cloudFlags.flags)
        if cloudFlagsHandler.getDeviceFlags().MainPowerSupplyDown != qrData.lpe {
            cloudFlagsHandler.setMainPowerSupply(down: qrData.lpe)
            setChannelFlags(qrData: qrData, flags: cloudFlagsHandler.getFlags(), completion: completion)
        } else {
            completion(nil)
        }
    }

    private func setChannelFlags(qrData: QRCode, flags: UInt64, completion: @escaping (AddPlacePipeline.Result) -> Void) {
        setChannelFlagsService.set(forUID: qrData.u, andChannel: qrData.ch, withFlags: flags) { [weak self] result in
            guard let self = self else { return completion(.connectivity) }

            guard let result = result else { return completion(nil) }
            completion(self.map(error: result))
        }
    }

    private func map(error: GetDeviceStatusService.Error) -> AddPlacePipelineError {
        switch error {
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        }
    }

    private func map(error: SetMasterSharingService.Result) -> AddPlacePipelineError? {
        switch error {
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

    private func map(error: GetChannelFlagsService.Error) -> AddPlacePipelineError {
        switch error {
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        }
    }

    private func map(error: SetChannelFlagsService.Error) -> AddPlacePipelineError {
        switch error {
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        }
    }
}
