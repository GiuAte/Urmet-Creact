//
//  CoreDataAlarmsStore.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 22/12/22.
//

import CoreData
import Foundation

class CoreDataAlarmsStore: AlarmsStore {
    private static let modelName = CoreDataPlaceHelper.modelName
    private static let model = CoreDataPlaceHelper.model

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    enum Error: Swift.Error {
        case ModelNotFound(name: String)
    }

    init(storeURL: URL) throws {
        guard let model = CoreDataAlarmsStore.model else {
            throw Error.ModelNotFound(name: CoreDataAlarmsStore.modelName)
        }

        container = try NSPersistentContainer.load(
            name: CoreDataAlarmsStore.modelName,
            model: model,
            url: storeURL
        )
        context = container.newBackgroundContext()
    }

    func insert(_ alarms: [Alarm], forPlace place: Place, completion: @escaping InsertCompletion) {
        perform { context in
            do {
                for alarm in alarms {
                    let managedAlarm = ManagedAlarm.managedAlarm(from: alarm, ofPlace: place, in: context)
                    let managedPlace = try ManagedPlace.find(in: context, withId: place.id)
                    managedAlarm.place = managedPlace
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
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedAlarm")
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
                let missedCalls = try ManagedAlarm.find(in: context, withId: place.id)
                completion(.success(missedCalls.map { $0.localAlarm }))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func clear(completion: @escaping DeleteCompletion) {
        perform { context in
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedAlarm")
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
