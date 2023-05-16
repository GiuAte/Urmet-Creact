//
//  CoreDataDevicesStore.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/12/22.
//

import CoreData
import Foundation

class CoreDataDevicesStore: DevicesStore {
    private static let modelName = CoreDataPlaceHelper.modelName
    private static let model = CoreDataPlaceHelper.model

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    enum Error: Swift.Error {
        case ModelNotFound(name: String)
    }

    init(storeURL: URL) throws {
        guard let model = CoreDataDevicesStore.model else {
            throw Error.ModelNotFound(name: CoreDataDevicesStore.modelName)
        }

        container = try NSPersistentContainer.load(
            name: CoreDataDevicesStore.modelName,
            model: model,
            url: storeURL
        )
        context = container.newBackgroundContext()
    }

    func insert(_ devices: [Device], forPlace place: Place, completion: @escaping InsertCompletion) {
        perform { context in
            do {
                for device in devices {
                    let managedDevice = ManagedDevice.managedDevice(from: device, ofPlace: place, in: context)
                    let managedPlace = try ManagedPlace.find(in: context, withId: place.id)
                    managedDevice.place = managedPlace
                }

                try context.save()
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    func delete(forPlace place: Place, completion: @escaping InsertCompletion) {
        perform { context in
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedDevice")
                let predicate = NSPredicate(format: "placeId = %@", place.id)
                fetchRequest.predicate = predicate
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(deleteRequest)
                try context.save()
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    func retrieveCameras(forPlace place: Place, completion: @escaping RetrieveCamerasCompletion) {
        perform { context in
            do {
                context.refreshAllObjects()
                let devices = try ManagedDevice.findCameras(in: context, withId: place.id)
                completion(.success(devices.map { $0.localCamera }))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func retrieveContacts(forPlace place: Place, completion: @escaping RetrieveContactsCompletion) {
        perform { context in
            do {
                context.refreshAllObjects()
                let devices = try ManagedDevice.findContacts(in: context, withId: place.id)
                completion(.success(devices.map { $0.localContact }))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func clear(completion: @escaping DeleteCompletion) {
        perform { context in
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedDevice")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(deleteRequest)
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
