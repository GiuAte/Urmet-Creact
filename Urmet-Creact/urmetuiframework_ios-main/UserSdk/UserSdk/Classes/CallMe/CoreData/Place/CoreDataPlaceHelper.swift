//
//  CoreDataPlaceHelper.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 28/06/22.
//

import CoreData

final class CoreDataPlaceHelper {
    static let modelName = "PlaceStore"
    static let placeModel = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataPlaceStore.self))!
    static let accountsModel = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataAccountStore.self))!
    static let missedCallsModel = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataMissedCallsStore.self))!
    static let alarmsModel = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataAlarmsStore.self))!
    static let devicesModel = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataDevicesStore.self))!
    static let managedObjects = [placeModel, accountsModel, missedCallsModel, alarmsModel, devicesModel]
    static let model = NSManagedObjectModel(byMerging: managedObjects)

    private init() {}
}

extension NSPersistentContainer {
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }

        return container
    }
}

extension NSManagedObjectModel {
    convenience init?(name: String, in bundle: Bundle) {
        guard let momd = bundle.url(forResource: name, withExtension: "momd") else {
            return nil
        }
        self.init(contentsOf: momd)
    }
}
