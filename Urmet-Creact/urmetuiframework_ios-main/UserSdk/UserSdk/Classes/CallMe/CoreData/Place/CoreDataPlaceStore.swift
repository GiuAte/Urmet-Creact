//
//  CoreDataPlaceStore.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 29/06/22.
//

import CoreData

class CoreDataPlaceStore: PlaceStore {
    private static let modelName = CoreDataPlaceHelper.modelName
    private static let model = CoreDataPlaceHelper.model

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    enum Error: Swift.Error {
        case ModelNotFound(name: String)
        case placeNotFound
    }

    init(storeURL: URL) throws {
        guard let model = CoreDataPlaceStore.model else {
            throw Error.ModelNotFound(name: CoreDataPlaceStore.modelName)
        }

        container = try NSPersistentContainer.load(
            name: CoreDataPlaceStore.modelName,
            model: model,
            url: storeURL
        )
        context = container.newBackgroundContext()

        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextDidSave), name: .NSManagedObjectContextDidSave, object: nil)
    }

    func retrieve(completion: @escaping RetrieveCompletion) {
        perform { context in
            do {
                let managedPlaces = try ManagedPlace.find(in: context)
                completion(.success(managedPlaces.map { $0.localPlace }))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func insert(_ place: Place, completion: @escaping InsertCompletion) {
        perform { context in
            do {
                ManagedPlace.managedPlace(from: place, in: context)
                try context.save()
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    func delete(_ place: Place, completion: @escaping DeleteCompletion) {
        perform { context in
            do {
                let managedPlace = try ManagedPlace.find(in: context, withId: place.id)
                if let managedPlace = managedPlace {
                    context.delete(managedPlace)
                }
                try context.save()
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    func update(_ place: Place, completion: @escaping UpdateCompletion) {
        perform { context in
            do {
                let managedPlace = try ManagedPlace.find(in: context, withId: place.id)
                if let managedPlace = managedPlace {
                    managedPlace.name = place.name
                    managedPlace.enabled = place.enabled
                    managedPlace.ipercomGatewayUri = place.ipercomGatewayUri
                    try context.save()
                    completion(nil)
                } else {
                    completion(CoreDataPlaceStore.Error.placeNotFound)
                }
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    func clear(completion: @escaping DeleteCompletion) {
        perform { context in
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedPlace")
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

    @objc func managedObjectContextDidSave(notification: Notification) {
        perform { context in
            context.mergeChanges(fromContextDidSave: notification)
        }
    }
}
