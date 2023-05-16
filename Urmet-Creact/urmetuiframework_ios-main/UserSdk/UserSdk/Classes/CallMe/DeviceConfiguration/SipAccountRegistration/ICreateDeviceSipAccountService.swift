//
//  ICreateDeviceSipAccountService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/10/22.
//

import Foundation

protocol ICreateDeviceSipAccountService {
    typealias Result = Swift.Result<Bool, Error>
    typealias Completion = (Result) -> Void

    func registerSipAccount(withQRCode qrCode: String, completion: @escaping ICreateDeviceSipAccountService.Completion)
}
