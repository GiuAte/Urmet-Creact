//
//  CoreDataAccountStore.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 28/06/22.
//

import CoreData
import Foundation

final class CoreDataAccountStore: AccountStore {
    private static let modelName = CoreDataPlaceHelper.modelName
    private static let model = CoreDataPlaceHelper.model

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    enum Error: Swift.Error {
        case ModelNotFound(name: String)
    }

    init(storeURL: URL) throws {
        guard let model = CoreDataAccountStore.model else {
            throw Error.ModelNotFound(name: CoreDataAccountStore.modelName)
        }

        container = try NSPersistentContainer.load(
            name: CoreDataAccountStore.modelName,
            model: model,
            url: storeURL
        )
        context = container.newBackgroundContext()
    }

    func insert(account: Account, completion: @escaping InsertCompletion) {
        perform { context in
            do {
                ManagedAccount.managedAccount(from: account, in: context)
                try context.save()
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    func retrieve(completion: @escaping Completion) {
        perform { context in
            do {
                let managedAccounts = try ManagedAccount.find(in: context)
                completion(.success(managedAccounts.map { $0.account }))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func delete(account: Account, completion: @escaping DeleteCompletion) {
        perform { context in
            do {
                let managedAccount = try ManagedAccount.find(
                    in: context,
                    withUsername: account.username,
                    andDirection: account.direction,
                    andChannelNumber: account.channelNumber
                )
                if let managedAccount = managedAccount {
                    context.delete(managedAccount)
                }
                try context.save()
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
