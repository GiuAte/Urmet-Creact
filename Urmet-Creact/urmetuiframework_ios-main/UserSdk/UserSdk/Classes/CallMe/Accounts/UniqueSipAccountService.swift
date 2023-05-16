//
//  UniqueSipAccountService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 15/11/22.
//

import Foundation

final class UniqueSipAccountService: IUniqueSipAccountService {
    private let expirationDays = 180
    private let usernameRegex = try! NSRegularExpression(pattern: "[!#$%&'*+-/=?^_`{|}~@]", options: [])
    private static let timestampPattern = "[0-9]{15}$"
    private let timestampRegex = try! NSRegularExpression(pattern: timestampPattern, options: [])

    private let accountStore: AccountStore
    private let createSipAccountService: CreateSipAccountService
    private let accountRegistrationManager: IAccountRegistrationManager

    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyMMddHHmmssSSS"
        return df
    }()

    init(accountStore: AccountStore, createSipAccountService: CreateSipAccountService, accountRegistrationManager: IAccountRegistrationManager) {
        self.accountStore = accountStore
        self.createSipAccountService = createSipAccountService
        self.accountRegistrationManager = accountRegistrationManager
    }

    func generate(forUsername username: String, andRealm realm: String, completion: @escaping GenerateCompletion) {
        accountStore.retrieve { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(accounts):
                if let retrivedAccount = accounts.first(where: { $0.direction == .instance }) {
                    if !self.isExpired(retrivedAccount.username),
                       self.isSameUser(retrievedUsername: retrivedAccount.username, receivedUsername: username)
                    {
                        return completion(.failure(.alreadyExists))
                    } else {
                        self.accountStore.delete(account: retrivedAccount) { _ in }
                    }
                }

                let account = self.makeAccount(username: username, realm: realm)
                self.createAccountOnCloud(account, completion: completion)

            case .failure:
                return completion(.failure(.generic))
            }
        }
    }

    func get(completion: @escaping GetCompletion) {
        accountStore.retrieve { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(accounts):
                if let account = accounts.first(where: { $0.direction == .instance }) {
                    if !self.isExpired(account.username) {
                        return completion(.success(account))
                    } else {
                        self.accountStore.delete(account: account) { _ in
                            completion(.failure(.accountNotFound))
                        }
                    }
                } else {
                    return completion(.failure(.accountNotFound))
                }

            case .failure:
                return completion(.failure(.generic))
            }
        }
    }

    private func isExpired(_ username: String) -> Bool {
        let currentDate = Date()

        guard
            let match = timestampRegex.matches(in: username, options: [], range: NSRange(location: 0, length: username.count)).first,
            let matchRange = Range(match.range, in: username)
        else { return false }

        let expirationStr = String(username[matchRange])
        guard let expirationDate = dateFormatter.date(from: expirationStr) else { return false }

        return expirationDate < currentDate
    }

    private func isSameUser(retrievedUsername: String, receivedUsername: String) -> Bool {
        let underscoredUsername = usernameSpecialCharsToUnderscores(username: receivedUsername)
        let range = NSRange(location: 0, length: retrievedUsername.count)
        let regex = try! NSRegularExpression(pattern: "cfwunique_\(underscoredUsername)_\(UniqueSipAccountService.timestampPattern)")
        return regex.firstMatch(in: retrievedUsername, options: [], range: range) != nil
    }
}

// MARK: - Generate

extension UniqueSipAccountService {
    // Account generation
    private func makeAccount(username: String, realm: String) -> Account {
        let username = makeUsername(username: username)
        let password = makePassword()

        return Account(username: username, password: password, realm: realm, direction: .instance, placeID: "", channelNumber: 0)
    }

    private func usernameSpecialCharsToUnderscores(username: String) -> String {
        return usernameRegex.stringByReplacingMatches(in: username, range: NSRange(location: 0, length: username.count), withTemplate: "_")
    }

    private func makeUsername(username: String) -> String {
        let usernameWithUnderscores = usernameSpecialCharsToUnderscores(username: username)
        let timestamp = makeTimestamp()

        return "cfwunique_\(usernameWithUnderscores)_\(timestamp)"
    }

    private func makeTimestamp() -> String {
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate.adding(days: expirationDays))

        return dateString
    }

    private func makePassword() -> String {
        return UUID().uuidString
    }

    private func createAccountOnCloud(_ account: Account, completion: @escaping GenerateCompletion) {
        createSipAccountService.create(accountWithUsername: account.username, andPassword: account.password, forRealm: account.realm) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                self.accountStore.insert(account: account) { _ in
                    self.accountRegistrationManager.sync {
                        completion(.success(account))
                    }
                }

            case let .failure(error as CreateSipAccountService.Error):
                completion(.failure(self.map(error)))
            default:
                completion(.failure(.generic))
            }
        }
    }

    private func map(_ error: CreateSipAccountService.Error) -> UniqueSipAccountGenerateError {
        switch error {
        case .connectivity:
            return .connectivity
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        }
    }
}
