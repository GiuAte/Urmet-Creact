//
//  ManagedDevice.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/12/22.
//

import CoreData

@objc(ManagedDevice)
final class ManagedDevice: NSManagedObject {
    @NSManaged var placeId: String
    @NSManaged var name: String
    @NSManaged var type: String
    @NSManaged var topological_code: String
    @NSManaged var vds_types: String
    @NSManaged var place: ManagedPlace?

    func getIpercomAttributes() -> IpercomDeviceAttributes {
        return IpercomDeviceAttributes(topological_code: topological_code, vds_types: vds_types)
    }
}

extension ManagedDevice {
    var localCamera: Camera {
        return Camera(name: name,
                      type: DeviceType(rawValue: type) ?? .Unknown,
                      ipercomAttributes: getIpercomAttributes())
    }

    var localContact: Contact {
        return Contact(name: name,
                       type: DeviceType(rawValue: type) ?? .Unknown,
                       ipercomAttributes: getIpercomAttributes())
    }

    @discardableResult
    static func managedDevice(from device: Device, ofPlace place: Place, in context: NSManagedObjectContext) -> ManagedDevice {
        let managedDevice = ManagedDevice(context: context)
        managedDevice.placeId = place.id
        managedDevice.name = device.name
        managedDevice.type = device.type.rawValue
        managedDevice.topological_code = device.ipercomAttributes.topological_code
        managedDevice.vds_types = device.ipercomAttributes.vds_types
        return managedDevice
    }

    static func find(in context: NSManagedObjectContext, withId id: String) throws -> [ManagedDevice] {
        let request = NSFetchRequest<ManagedDevice>(entityName: entity().name!)
        let predicate = NSPredicate(format: "placeId = %@", id)
        request.predicate = predicate
        return try context.fetch(request)
    }

    static func findCameras(in context: NSManagedObjectContext, withId id: String) throws -> [ManagedDevice] {
        let request = NSFetchRequest<ManagedDevice>(entityName: entity().name!)
        let cameraTypes = DeviceType.allCases.filter { $0.isCamera }.map { $0.rawValue }
        let predicate = NSPredicate(format: "placeId = %@ && type IN %@", id, cameraTypes)
        request.predicate = predicate
        return try context.fetch(request)
    }

    static func findContacts(in context: NSManagedObjectContext, withId id: String) throws -> [ManagedDevice] {
        let request = NSFetchRequest<ManagedDevice>(entityName: entity().name!)
        let contactsTypes = DeviceType.allCases.filter { $0.isContact }.map { $0.rawValue }
        let predicate = NSPredicate(format: "placeId = %@ && type IN %@", id, contactsTypes)
        request.predicate = predicate
        return try context.fetch(request)
    }
}
