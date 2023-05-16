//
//  AccountRegistrationManager.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 09/11/22.
//

import Foundation

final class AccountRegistrationManager: IAccountRegistrationManager {
    private var domain: String
    private var accountStore: AccountStore
    private var placeStore: PlaceStore
    private var registrationClient: RegistrationSipClient
    private var registrationService: SipRegistrationService
    private let allowedAccounts: [AccountDirection] = [.instance, .bidirectional]

    init(domain: String, accountStore: AccountStore, placeStore: PlaceStore, registrationClient: RegistrationSipClient) {
        self.domain = domain
        self.accountStore = accountStore
        self.placeStore = placeStore
        self.registrationClient = registrationClient
        registrationService = SipRegistrationService(client: self.registrationClient)
    }

    private struct CompletionWaiter {
        let totalCount: Int
        var currentCount: Int = 0 { didSet { checkCompletion() } }
        let completion: Completion

        mutating func increment() {
            currentCount += 1
        }

        mutating func checkCompletion() {
            if currentCount == totalCount {
                completion()
            }
        }
    }

    private struct RegistrableAccount {
        let account: UserSdk.Account
        let params: RegistrationParams
    }

    func sync(completion: @escaping Completion) {
        var completionWaiter = CompletionWaiter(totalCount: 2, completion: completion)

        accountStore.retrieve { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(accounts):
                let filteredAccounts = accounts.filter { self.allowedAccounts.contains($0.direction) }
                let registrableAccounts = self.getRegistrableAccounts(forAccounts: filteredAccounts)
                self.sync(accounts: registrableAccounts) {
                    completionWaiter.increment()
                }
            default:
                // TODO: Log error
                break
            }
        }

        placeStore.retrieve { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(places):
                let registrableAccounts = self.getRegistrableAccounts(forPlaces: places)
                self.sync(accounts: registrableAccounts) {
                    completionWaiter.increment()
                }
            default:
                // TODO: Log error
                break
            }
        }
    }

    private func getRegistrableAccounts(forPlaces places: [Place]) -> [RegistrableAccount] {
        var accounts: [RegistrableAccount] = []

        for place in places {
            let registrableAccounts = place.accounts.filter { $0.direction == .incoming }

            for account in registrableAccounts {
                let params = RegistrationParams(domain: account.realm, expire: 10_080_000, registerEnabled: place.enabled, remotePushAllowed: true)
                accounts.append(RegistrableAccount(account: account, params: params))
            }
        }

        return accounts
    }

    private func getRegistrableAccounts(forAccounts accounts: [UserSdk.Account]) -> [RegistrableAccount] {
        var registrableAccounts: [RegistrableAccount] = []

        for account in accounts {
            let params = RegistrationParams(domain: account.realm, expire: 10_080_000, registerEnabled: true, remotePushAllowed: true)
            registrableAccounts.append(RegistrableAccount(account: account, params: params))
        }

        return registrableAccounts
    }

    private func sync(accounts: [RegistrableAccount], completion: @escaping Completion) {
        if accounts.count == 0 {
            completion()
        }

        var completionWaiter = CompletionWaiter(totalCount: accounts.count, completion: completion)

        for account in accounts {
            DispatchQueue.main.async {
                self.registrationService.register(account.account, withParams: account.params) { _ in
                    completionWaiter.increment()
                }
            }
        }
    }
}
