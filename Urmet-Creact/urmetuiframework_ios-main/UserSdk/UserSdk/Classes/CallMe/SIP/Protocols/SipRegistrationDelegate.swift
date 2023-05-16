//
//  SipRegistrationDelegate.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 14/07/22.
//

import Foundation

protocol SipRegistrationDelegate {
    var registrationStateChanged: (([AccountState]) -> Void)? { get }
}
