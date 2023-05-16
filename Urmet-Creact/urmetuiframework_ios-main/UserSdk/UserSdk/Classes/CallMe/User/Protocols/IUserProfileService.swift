//
//  IUserProfileService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 11/10/22.
//

import Foundation

public enum IUserProfileServiceError: Swift.Error {
    case connectivity
    case unauthorized
    case invalidData
    case missingStatement
    case invalidResponse
    case invalidOrigin
}

public protocol IUserProfileService {
    typealias GetUserInfoResult = Swift.Result<UserProfile, Error>
    typealias GetUserInfoCompletion = (GetUserInfoResult) -> Void

    typealias PendingDeletionCompletion = (Error?) -> Void

    typealias GetUserGDPRStatusResult = Swift.Result<[GDPRStatementStatus], Error>
    typealias GetUserGDPRStatusCompletion = (GetUserGDPRStatusResult) -> Void

    typealias UpdateUserGDPRStatusCompletion = (Error?) -> Void

    func getUserInfo(completion: @escaping GetUserInfoCompletion)
    func setPendingDeletion(completion: @escaping PendingDeletionCompletion)
    func getUserGDPRStatus(completion: @escaping GetUserGDPRStatusCompletion)
    func updateUserGDPRStatus(withStatements statements: [GDPRStatementToUpload], completion: @escaping UpdateUserGDPRStatusCompletion)
}
