//
//  ManagedPlace.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 29/06/22.
//

import CoreData

@objc(ManagedPlace)
final class ManagedPlace: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var uid: String?
    @NSManaged var name: String
    @NSManaged var capabilities: NSSet
    @NSManaged var accounts: NSSet
    @NSManaged var ipercomGatewayUri: String?
    @NSManaged var mac: String?
    @NSManaged var family: String
    @NSManaged var model: String
    @NSManaged var strategies: NSSet
    @NSManaged var enabled: Bool
    @NSManaged var missedCalls: NSSet
    @NSManaged var alarms: NSSet
}

extension ManagedPlace {
    var localPlace: Place {
        return Place(
            id: id,
            uid: uid,
            name: name,
            capabilities: capabilities.compactMap { PlaceCapability(rawValue: $0 as? String ?? "") },
            accounts: accounts.compactMap { ($0 as? ManagedAccount)?.account },
            ipercomGatewayUri: ipercomGatewayUri,
            mac: mac,
            family: PlaceFamilyType(rawValue: family)!,
            model: PlaceType(rawValue: model)!,
            strategies: strategies.compactMap { PlaceStrategy(rawValue: $0 as? String ?? "") },
            enabled: enabled
        )
    }

    @discardableResult
    static func managedPlace(from place: Place, in context: NSManagedObjectContext) -> ManagedPlace {
        let managedPlace = ManagedPlace(context: context)
        managedPlace.id = place.id
        managedPlace.uid = place.uid
        managedPlace.name = place.name
        managedPlace.accounts = NSSet(array: place.accounts.map { ManagedAccount.managedAccount(from: $0, in: context) })
        managedPlace.capabilities = NSSet(array: place.capabilities.map { $0.rawValue })
        managedPlace.ipercomGatewayUri = place.ipercomGatewayUri
        managedPlace.mac = place.mac
        managedPlace.family = place.family.rawValue
        managedPlace.model = place.model.rawValue
        managedPlace.strategies = NSSet(array: place.strategies.map { $0.rawValue })
        managedPlace.enabled = place.enabled
        return managedPlace
    }

    static func find(in context: NSManagedObjectContext) throws -> [ManagedPlace] {
        let request = NSFetchRequest<ManagedPlace>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }

    static func find(in context: NSManagedObjectContext, withId id: String) throws -> ManagedPlace? {
        let request = NSFetchRequest<ManagedPlace>(entityName: entity().name!)
        let predicate = NSPredicate(format: "id = %@", id)
        request.predicate = predicate
        return try context.fetch(request).first
    }
}
