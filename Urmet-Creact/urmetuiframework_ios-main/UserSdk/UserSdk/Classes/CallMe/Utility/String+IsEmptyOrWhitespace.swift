//
//  String+IsEmptyOrWhitespace.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 27/09/22.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
