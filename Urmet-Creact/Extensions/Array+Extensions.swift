//
//  Array+Extensions.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 15/05/23.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
      }
}
