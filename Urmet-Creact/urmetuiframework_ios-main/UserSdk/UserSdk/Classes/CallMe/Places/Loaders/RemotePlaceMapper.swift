//
//  RemotePlaceMapper.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 22/06/22.
//

import Foundation

final class RemotePlaceMapper {
    private struct RootResponse {
        let data: [[String: Any]]

        func toResponseItem() -> [ResponseItem] {
            return data.map { ResponseItem(item: $0) }
        }
    }

    private struct ResponseItem {
        let item: [String: Any]

        var type: PlaceType {
            return PlaceType(rawValue: item["uid_type"] as! String) ?? .Unknown
        }

        func toData() -> Data {
            return try! JSONSerialization.data(withJSONObject: item)
        }
    }

    private static let strategyMapping: [PlaceGroupType: [PlaceStrategy]] = [
        .Group_1083_83: [.CFWMissedCalls],
        .Group_Ipercom: [.IpercomMissedCalls, .IpercomAlarms, .IpercomDevices],
        .Group_1760_16: [.VOG5MissedCalls, .VOG5Alarms],
        .Group_1760_31: [.IpercomMissedCalls, .IpercomAlarms, .IpercomDevices],
    ]

    private init() {}

    static func map(_ data: Data, _ response: HTTPURLResponse, _ realm: String) -> RemotePlaceLoader.LoadResult {
        if response.statusCode == 401 {
            return .failure(RemotePlaceLoader.Error.unauthorized)
        }

        guard let responseItems = try? getResponseItems(data) else { return .failure(RemotePlaceLoader.Error.invalidData) }
        let internalPlaces = map(responseItems)

        return map(internalPlaces, realm)
    }

    private static func getResponseItems(_ data: Data) throws -> [ResponseItem] {
        guard let serverJSONObject = try? JSONSerialization.jsonObject(with: data),
              let parsedJSONBody = serverJSONObject as? [String: Any],
              let jsonBodyData = parsedJSONBody["data"] as? [[String: Any]]
        else {
            throw RemotePlaceLoader.Error.invalidData
        }

        let rootResponse = RootResponse(data: jsonBodyData)
        return rootResponse.toResponseItem()
    }

    private static func map(_ items: [ResponseItem]) -> [InternalPlace] {
        var places = [InternalPlace]()
        for item in items {
            switch item.type {
            case .Unknown:
                print("unknown device \(item.item)")

            default:
                if let place = convert(item, toType: GenericInternalPlace.self) {
                    places.append(place)
                }
            }
        }

        return places
    }

    private static func convert<T: Decodable>(_ item: ResponseItem, toType type: T.Type) -> T? {
        if let place = try? JSONDecoder().decode(type, from: item.toData()) {
            return place
        }
        return nil
    }

    private static func map(_ internalPlaces: [InternalPlace], _ realm: String) -> RemotePlaceLoader.LoadResult {
        let places: [Place] = internalPlaces.map {
            let name = $0.relationName.isEmpty ? "Apt-\($0.channelNumber)" : $0.relationName
            let accounts = [
                Account(username: $0.incCredentialUsername, password: $0.incCredentialPassword, realm: realm, direction: .incoming, placeID: $0.id, channelNumber: $0.channelNumber),
                Account(username: $0.outCredentialUsername, password: $0.outCredentialPassword, realm: realm, direction: .outgoing, placeID: $0.id, channelNumber: $0.channelNumber),
            ]

            return Place(
                id: $0.id,
                uid: $0.uid,
                name: name,
                capabilities: map($0),
                accounts: accounts,
                ipercomGatewayUri: nil,
                mac: $0.mac,
                family: getPlaceFamily($0),
                model: $0.type,
                strategies: getStrategies($0),
                enabled: true
            )
        }

        return .success(places)
    }

    private static func map(_ internalPlace: InternalPlace) -> [PlaceCapability] {
        var capabilities: [PlaceCapability] = []
        if internalPlace.isSharable {
            capabilities.append(.isSharable)
        }

        if let placeFlags = internalPlace.flags,
           !FlagsHandler(flags: placeFlags).getDeviceFlags().MainPowerSupplyDown
        {
            capabilities.append(.isContactable)
        } else if internalPlace.flags == nil {
            capabilities.append(.isContactable)
        }

        return capabilities
    }

    private static func getPlaceFamily(_ internalPlace: InternalPlace) -> PlaceFamilyType {
        switch internalPlace.type {
        case .DeviceIpercom:
            return .Ipercom
        default:
            return .TwoVoice
        }
    }

    private static func getStrategies(_ internalPlace: InternalPlace) -> [PlaceStrategy] {
        let placeGroupType = PlaceTypeGroupMapper.getType(internalPlace.type)
        guard
            placeGroupType != .Unknown,
            let strategies = strategyMapping[placeGroupType]
        else { return [] }

        return strategies
    }
}
