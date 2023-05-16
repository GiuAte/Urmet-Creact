//
//  PlaceTypeGroupMapper.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 06/07/22.
//

import Foundation

final class PlaceTypeGroupMapper {
    private struct QRModel: Decodable {
        let m: PlaceType
        let token: String?

        enum CodingKeys: CodingKey {
            case m
            case s
            case token
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let mValue = try? container.decodeIfPresent(PlaceType.self, forKey: .m) {
                m = mValue!
            } else if let sValue = try? container.decodeIfPresent(PlaceType.self, forKey: .s) {
                m = sValue!
            } else {
                throw DecodingError.keyNotFound(CodingKeys.m, DecodingError.Context(codingPath: [CodingKeys.m], debugDescription: "model not found"))
            }

            token = try container.decodeIfPresent(String.self, forKey: PlaceTypeGroupMapper.QRModel.CodingKeys.token)
        }
    }

    private static let mapping: [PlaceGroupType: [PlaceType]] = [
        .Group_1083_83: [.Device1083_83],
        .Group_Ipercom: [.DeviceIpercom],
        .Group_1760_16: [.Device1760_15, .Device1760_16, .Device1760_18, .Device1760_19],
        .Group_1760_31: [.Device1760_31],
    ]

    static func getType(_ qr: String) -> PlaceGroupType {
        guard let model = try? JSONDecoder().decode(QRModel.self, from: qr.data(using: .utf8)!) else {
            return .Unknown
        }

        if model.token != nil {
            return .Group_SharingToken
        }

        for (groupType, placeTypes) in mapping {
            if placeTypes.contains(model.m) {
                return groupType
            }
        }

        return .Unknown
    }

    static func getType(_ model: PlaceType) -> PlaceGroupType {
        for (groupType, placeTypes) in mapping {
            if placeTypes.contains(model) {
                return groupType
            }
        }

        return .Unknown
    }
}
