//
//  ManagedAlarm.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 22/12/22.
//

import CoreData

@objc(ManagedAlarm)
final class ManagedAlarm: NSManagedObject {
    @NSManaged var placeId: String
    @NSManaged var sender: String?
    @NSManaged var state: String
    @NSManaged var ts: UInt64
    @NSManaged var type: String
    @NSManaged var topological_code: String?
    @NSManaged var vds_types: String?
    @NSManaged var mac: String?
    @NSManaged var place: ManagedPlace?

    func getIpercomAttributes() -> IpercomAlarmAttributes? {
        guard let topological_code,
              let vds_types
        else {
            return nil
        }

        return IpercomAlarmAttributes(topological_code: topological_code, vds_types: vds_types)
    }

    func getCfwAlarmAttributes() -> CfwAlarmAttributes? {
        guard let mac else {
            return nil
        }

        return CfwAlarmAttributes(mac: mac)
    }
}

extension ManagedAlarm {
    var localAlarm: Alarm {
        return Alarm(sender: sender,
                     state: AlarmState(rawValue: state) ?? .Unknown,
                     ts: ts,
                     type: AlarmType(rawValue: type) ?? .Unknown,
                     ipercomAttributes: getIpercomAttributes(),
                     cfwAttributes: getCfwAlarmAttributes())
    }

    @discardableResult
    static func managedAlarm(from alarm: Alarm, ofPlace place: Place, in context: NSManagedObjectContext) -> ManagedAlarm {
        let managedAlarm = ManagedAlarm(context: context)
        managedAlarm.placeId = place.id
        managedAlarm.sender = alarm.sender
        managedAlarm.state = alarm.state.rawValue
        managedAlarm.ts = alarm.ts
        managedAlarm.type = alarm.type.rawValue
        managedAlarm.topological_code = alarm.ipercomAttributes?.topological_code
        managedAlarm.vds_types = alarm.ipercomAttributes?.vds_types
        managedAlarm.mac = alarm.cfwAttributes?.mac
        return managedAlarm
    }

    static func find(in context: NSManagedObjectContext, withId id: String) throws -> [ManagedAlarm] {
        let request = NSFetchRequest<ManagedAlarm>(entityName: entity().name!)
        let predicate = NSPredicate(format: "placeId = %@", id)
        request.predicate = predicate
        return try context.fetch(request)
    }
}
