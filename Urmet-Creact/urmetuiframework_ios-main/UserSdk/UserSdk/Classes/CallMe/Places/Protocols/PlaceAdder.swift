//
//  PlaceAdder.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 28/09/22.
//

import Foundation

protocol PlaceAdder {
    typealias AddResult = Swift.Result<Place?, Error>

    func add(fromQRCode qr: String, completion: @escaping (AddResult) -> Void)
}
