//
//  ManagedMissedCall.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 16/12/22.
//

import CoreData

@objc(ManagedMissedCall)
final class ManagedMissedCall: NSManagedObject {
    @NSManaged var placeId: String
    @NSManaged var caller: String
    @NSManaged var hasSnapshot: Bool
    @NSManaged var ts: UInt64
    @NSManaged var call_type: String?
    @NSManaged var caller_code: String?
    @NSManaged var mac: String?
    @NSManaged var place: ManagedPlace?

    func getIpercomAttributes() -> IpercomMissedCallAttributes? {
        guard let call_type,
              let caller_code
        else {
            return nil
        }

        return IpercomMissedCallAttributes(call_type: call_type, caller_code: caller_code)
    }

    func getCfwMissedCallAttributes() -> CfwMissedCallAttributes? {
        guard let mac else {
            return nil
        }

        return CfwMissedCallAttributes(mac: mac)
    }
}

extension ManagedMissedCall {
    var localMissedCall: MissedCall {
        return MissedCall(caller: caller,
                          hasSnapshot: hasSnapshot,
                          ts: ts,
                          ipercomAttributes: getIpercomAttributes(),
                          cfwAttributes: getCfwMissedCallAttributes())
    }

    @discardableResult
    static func managedMissedCall(from missedCall: MissedCall, ofPlace place: Place, in context: NSManagedObjectContext) -> ManagedMissedCall {
        let managedMissedCall = ManagedMissedCall(context: context)
        managedMissedCall.placeId = place.id
        managedMissedCall.caller = missedCall.caller
        managedMissedCall.hasSnapshot = missedCall.hasSnapshot
        managedMissedCall.ts = missedCall.ts
        managedMissedCall.call_type = missedCall.ipercomAttributes?.call_type
        managedMissedCall.caller_code = missedCall.ipercomAttributes?.caller_code
        managedMissedCall.mac = missedCall.cfwAttributes?.mac
        return managedMissedCall
    }

    static func find(in context: NSManagedObjectContext, withId id: String) throws -> [ManagedMissedCall] {
        let request = NSFetchRequest<ManagedMissedCall>(entityName: entity().name!)
        let predicate = NSPredicate(format: "placeId = %@", id)
        request.predicate = predicate
        return try context.fetch(request)
    }
}
