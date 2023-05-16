//
//  ConfigurationQRCodeTypeMapper.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 03/11/22.
//

import Foundation

class ConfigurationQRCodeTypeMapper {
    enum QRType {
        case Mac
        case Json
        case Unknown
    }

    private struct QRJsonModel: Decodable {
        let M: String /// MAC Address
    }

    private func decodeQR(qr: String) -> QRJsonModel? {
        guard let decodedQR = try? JSONDecoder().decode(QRJsonModel.self, from: qr.data(using: .utf8)!) else {
            return nil
        }

        return decodedQR
    }

    static func isMacQRValid(_ qrCode: String) -> Bool {
        let pattern = "#(([a-fA-F0-9]{2}){6})#"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: qrCode.count)

        return !regex.matches(in: qrCode, options: [], range: range).isEmpty
    }

    static func getType(_ qr: String) -> QRType {
        if (try? JSONDecoder().decode(QRJsonModel.self, from: qr.data(using: .utf8)!)) != nil {
            return .Json
        }

        if isMacQRValid(qr) {
            return .Mac
        }

        return .Unknown
    }
}
