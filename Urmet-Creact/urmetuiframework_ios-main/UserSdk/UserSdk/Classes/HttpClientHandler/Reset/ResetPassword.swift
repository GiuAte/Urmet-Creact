//
//  Registration.swift
//  CallMeSdk
//
//  Created by Silvio Fosso on 26/01/23.
//

import Foundation
public class ResetPassword {
    private var resetPasswordService: IResetPasswordService?
    private var userProfileService: IUserProfileService?

    public weak var delegate: IResetPassword?

    public init() {
        resetPasswordService = HttpHandler.shared.getSdk()?.getResetPasswordService()
        userProfileService = HttpHandler.shared.getSdk()?.getUserProfileService()
    }

    public func resetPassword(email: String) {
        executeResetPassword(email: email)
    }

    public func resetPasswordIfLogged() {
        executeResetPasswordAlreadyLogged()
    }
}

extension ResetPassword {
    private func executeResetPasswordAlreadyLogged() {
        userProfileService?.getUserInfo {
            result in
            switch result {
            case let .success(userProfile):
                self.resetPasswordService?.resetPassword(forAccountWithEmail: userProfile.email) { error in
                    if let error {
                        self.delegate?.error(error: error)
                    } else {
                        self.delegate?.success(value: true)
                    }
                }
            case let .failure(error):
                self.delegate?.error(error: error)
            }
        }
    }

    private func executeResetPassword(email: String) {
        resetPasswordService?.resetPassword(forAccountWithEmail: email) { error in
            if let error {
                self.delegate?.error(error: error)
            } else {
                self.delegate?.success(value: true)
            }
        }
    }
}
