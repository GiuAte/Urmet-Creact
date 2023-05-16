//
//  UserProfileWithAccountsService.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 18/10/22.
//

import Foundation

final class UserProfileWithAccountsService: IUserProfileService {
    func getUserInfo(completion _: @escaping GetUserInfoCompletion) {}

    private let profileService: IUserProfileService

    init(profileService: IUserProfileService) {
        self.profileService = profileService
    }

    func setPendingDeletion(completion: @escaping PendingDeletionCompletion) {
        profileService.setPendingDeletion(completion: completion)
    }

    func getUserGDPRStatus(completion: @escaping GetUserGDPRStatusCompletion) {
        profileService.getUserGDPRStatus(completion: completion)
    }

    func updateUserGDPRStatus(withStatements statements: [GDPRStatementToUpload], completion: @escaping UpdateUserGDPRStatusCompletion) {
        profileService.updateUserGDPRStatus(withStatements: statements, completion: completion)
    }

    private func map(_ error: RemoteUserSipAccountLoader.Error) -> IUserProfileServiceError {
        switch error {
        case .unauthorized:
            return .unauthorized
        case .invalidData:
            return .invalidData
        case .connectivity:
            return .connectivity
        }
    }
}
