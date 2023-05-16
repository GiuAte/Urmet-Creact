//
//  PlaceSaver.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 04/08/22.
//

import Foundation

protocol PlaceSaver {
    typealias Completion = (Error?) -> Void

    func insert(_ places: [Place], completion: @escaping Completion)
}
