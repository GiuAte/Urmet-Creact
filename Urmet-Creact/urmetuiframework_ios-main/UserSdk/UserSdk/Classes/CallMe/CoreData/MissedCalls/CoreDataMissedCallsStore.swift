//
//  CoreDataMissedCallsStore.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 16/12/22.
//

import CoreData
import Foundation

class CoreDataMissedCallsStore: MissedCallsStore {
    private static let modelName = CoreDataPlaceHelper.modelName
    private static let model = CoreDataPlaceHelper.model

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    enum Error: Swift.Error {
        case ModelNotFound(name: String)
    }

    init(storeURL: URL) throws {
        guard let model = CoreDataMissedCallsStore.model else {
            throw Error.ModelNotFound(name: CoreDataMissedCallsStore.modelName)
        }

        container = try NSPersistentContainer.load(
            name: CoreDataMissedCallsStore.modelName,
            model: model,
            url: storeURL
        )
        context = container.newBackgroundContext()
    }

    func insert(_ missedCalls: [MissedCall], forPlace place: Place, completion: @escaping InsertCompletion) {
        perform { context in
            do {
                for missedCall in missedCalls {
                    let managedMissedCall = ManagedMissedCall.managedMissedCall(from: missedCall, ofPlace: place, in: context)
                    let managedPlace = try ManagedPlace.find(in: context, withId: place.id)
                    managedMissedCall.place = managedPlace
                }

                try context.save()
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    func delete(forPlace place: Place, completion: @escaping DeleteCompletion) {
        perform { context in
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedMissedCall")
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

    func retrieve(forPlace place: Place, completion: @escaping RetrieveCompletion) {
        perform { context in
            do {
                context.refreshAllObjects()
                let missedCalls = try ManagedMissedCall.find(in: context, withId: place.id)
                completion(.success(missedCalls.map { $0.localMissedCall }))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func clear(completion: @escaping DeleteCompletion) {
        perform { context in
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedMissedCall")
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
