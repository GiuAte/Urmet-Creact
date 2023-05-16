//
//  ManagedAccount.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 28/06/22.
//

import CoreData

@objc(ManagedAccount)
final class ManagedAccount: NSManagedObject {
    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var realm: String
    @NSManaged var direction: String
    @NSManaged var channelNumber: Int
    @NSManaged var place: ManagedPlace?
}

extension ManagedAccount {
    var account: Account {
        return Account(username: username, password: password, realm: realm, direction: AccountDirection(rawValue: direction)!, placeID: place?.id ?? "", channelNumber: channelNumber)
    }

    @discardableResult
    static func managedAccount(from account: Account, in context: NSManagedObjectContext) -> ManagedAccount {
        let managedAccount = ManagedAccount(context: context)
        managedAccount.username = account.username
        managedAccount.password = account.password
        managedAccount.realm = account.realm
        managedAccount.direction = account.direction.rawValue
        managedAccount.channelNumber = account.channelNumber
        return managedAccount
    }

    static func find(in context: NSManagedObjectContext) throws -> [ManagedAccount] {
        let request = NSFetchRequest<ManagedAccount>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }

    static func find(in context: NSManagedObjectContext, withUsername username: String, andDirection direction: AccountDirection, andChannelNumber channelNumber: Int) throws -> ManagedAccount? {
        let request = NSFetchRequest<ManagedAccount>(entityName: entity().name!)
        let predicate = NSPredicate(format: "username == %@ AND direction == %@ AND channelNumber == %d", username, direction.rawValue, channelNumber)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
}
