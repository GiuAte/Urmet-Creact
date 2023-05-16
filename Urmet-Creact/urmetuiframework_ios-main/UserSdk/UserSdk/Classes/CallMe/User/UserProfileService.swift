//
//  UserProfileService.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 21/07/22.
//

import Foundation

public final class UserProfileService: IUserProfileService {
    private let OK = 200
    private let NOT_AUTHORIZED = 401

    private let client: HTTPClient
    private let baseURL: URL
    private let accountStore: AccountStore
    private let origin: String

    private let getUserInfoResourcePath = "/tool/multiapi/private/getuserprofile/"
    private let updateUserProfileResourcePath = "/tool/multiapi/private/updateuserprofile/"
    private let getGDPRStatusResourcePath = "/tool/multiapi/private/user/getGDPR_status"
    private let updateGDPRStatusResourcePath = "/tool/multiapi/private/updateuserGDPR/"

    init(client: HTTPClient, baseURL: URL, accountStore: AccountStore, origin: String) {
        self.client = client
        self.baseURL = baseURL
        self.accountStore = accountStore
        self.origin = origin
    }

    // MARK: - getUserInfo

    public func getUserInfo(completion: @escaping GetUserInfoCompletion) {
        let url = baseURL.appendingPathComponent(getUserInfoResourcePath)

        client.get(fromURL: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success((data, httpResponse)):
                self.mapGetUserInfo(data, httpResponse, completion: completion)

            default:
                completion(.failure(IUserProfileServiceError.connectivity))
            }
        }
    }

    private struct GetUserInfoResponse: Decodable {
        let email: String
        let name: String
        let surname: String
        let pendingDeletion: String?
    }

    private func mapGetUserInfo(_ data: Data, _ httpResponse: HTTPURLResponse, completion: @escaping GetUserInfoCompletion) {
        if httpResponse.statusCode == NOT_AUTHORIZED {
            return completion(.failure(IUserProfileServiceError.unauthorized))
        }
        guard httpResponse.statusCode == OK, let resp = try? JSONDecoder().decode(GetUserInfoResponse.self, from: data) else {
            return completion(.failure(IUserProfileServiceError.invalidData))
        }

        accountStore.retrieve { result in
            switch result {
            case let .success(accounts):
                if let currentSipAccount = accounts.filter({ $0.direction == .bidirectional }).first {
                    return completion(.success(UserProfile(email: resp.email, name: resp.name, surname: resp.surname, pendingDeletion: resp.pendingDeletion, currentSipId: currentSipAccount.username)))
                } else {
                    return completion(.failure(IUserProfileServiceError.invalidData))
                }
            case .failure:
                return completion(.failure(IUserProfileServiceError.invalidData))
            }
        }
    }

    // MARK: - setPendingDeletion

    public func setPendingDeletion(completion: @escaping PendingDeletionCompletion) {
        let url = baseURL.appendingPathComponent(updateUserProfileResourcePath)

        struct Request: Encodable {
            let pendingDeletion: String
        }
        let deletionBody = Request(pendingDeletion: "1")
        guard let deletionBodyData = try? JSONEncoder().encode(deletionBody) else { return completion(IUserProfileServiceError.invalidData) }

        client.post(toURL: url, withHeaders: [:], andBody: deletionBodyData) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success((data, httpResponse)):
                completion(self.mapSetPendingDeletion(data, httpResponse))

            default:
                completion(IUserProfileServiceError.connectivity)
            }
        }
    }

    private func mapSetPendingDeletion(_: Data, _ httpResponse: HTTPURLResponse) -> IUserProfileServiceError? {
        if httpResponse.statusCode == NOT_AUTHORIZED {
            return .unauthorized
        } else if httpResponse.statusCode != OK {
            return .invalidData
        }

        return nil
    }

    // MARK: - getGDPRStatus

    private struct GetGDPRStatusRequest: Encodable {
        let origin: String
    }

    public func getUserGDPRStatus(completion: @escaping GetUserGDPRStatusCompletion) {
        let url = baseURL.appendingPathComponent(getGDPRStatusResourcePath)

        let request = GetGDPRStatusRequest(origin: origin)
        let body = try! JSONEncoder().encode(request)

        client.post(toURL: url, withHeaders: [:], andBody: body) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                completion(.failure(IUserProfileServiceError.connectivity))

            case let .success((data, httpResponse)):
                completion(self.mapGetUserGDPRStatus(data, httpResponse))
            }
        }
    }

    private func mapGetUserGDPRStatus(_ data: Data, _ httpStatus: HTTPURLResponse) -> GetUserGDPRStatusResult {
        if httpStatus.statusCode == NOT_AUTHORIZED {
            return .failure(IUserProfileServiceError.unauthorized)
        } else if httpStatus.statusCode != OK {
            return .failure(IUserProfileServiceError.invalidData)
        }

        guard
            let status = try? JSONDecoder().decode([GDPRStatementStatus].self, from: data)
        else { return .failure(IUserProfileServiceError.invalidData) }

        return .success(status)
    }

    // MARK: - updateGDPRStatus

    struct UpdateUserGDPRStatusRequest: Encodable {
        public let origin: String
        public let gdprStatements: [GDPRStatementToUpload]

        enum CodingKeys: String, CodingKey {
            case origin
            case gdprStatements = "stm_list"
        }
    }

    public func updateUserGDPRStatus(withStatements statements: [GDPRStatementToUpload], completion: @escaping UpdateUserGDPRStatusCompletion) {
        let url = baseURL.appendingPathComponent(updateGDPRStatusResourcePath)

        let request = UpdateUserGDPRStatusRequest(origin: origin, gdprStatements: statements)
        let body = try! JSONEncoder().encode(request)

        client.post(toURL: url, withHeaders: [:], andBody: body) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success((data, httpResponse)):
                completion(self.mapUpdateGDPRStatus(data, httpResponse))

            default:
                completion(IUserProfileServiceError.connectivity)
            }
        }
    }

    private func mapUpdateGDPRStatus(_ data: Data, _ httpResponse: HTTPURLResponse) -> IUserProfileServiceError? {
        if httpResponse.statusCode == NOT_AUTHORIZED {
            return .unauthorized
        } else if httpResponse.statusCode != OK {
            return .invalidData
        }

        return mapUpdateGDPRStatusResponsePayload(data)
    }

    private func mapUpdateGDPRStatusResponsePayload(_ data: Data) -> IUserProfileServiceError? {
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: String] {
            if (jsonResponse?.contains(where: { $0.key == "missed_mandatory_stm" || $0.key == "missed_stm" })) != nil {
                return IUserProfileServiceError.missingStatement
            } else if (jsonResponse?.contains(where: { $0.key == "gdpr retrive statements failed, check origin" })) != nil {
                return IUserProfileServiceError.invalidOrigin
            } else if (jsonResponse?.contains(where: { $0.key == "GDPR update" && $0.value == "success" })) != nil {
                return nil
            }
        }

        return IUserProfileServiceError.invalidResponse
    }
}
