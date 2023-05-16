//
//  AccountState.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 14/07/22.
//

import Foundation

enum AccountRegistrationStatus {
    case None
    case InProgress
    case Ok
    case Failed
}

struct AccountState: Hashable {
    let account: UserSdk.Account
    let state: AccountRegistrationStatus
}
