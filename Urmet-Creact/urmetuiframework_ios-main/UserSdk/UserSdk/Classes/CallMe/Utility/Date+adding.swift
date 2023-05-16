//
//  Date+adding.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 15/11/22.
//

import Foundation

extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}
