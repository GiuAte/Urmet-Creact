//
//  RegistrationParams.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 01/09/22.
//

import Foundation

struct RegistrationParams {
    let domain: String
    let expire: Int
    let registerEnabled: Bool
    let remotePushAllowed: Bool
}
