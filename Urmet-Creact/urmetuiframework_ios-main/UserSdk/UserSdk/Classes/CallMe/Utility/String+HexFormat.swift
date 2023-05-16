//
//  String+CodableBase64.swift
//  CallMeSdk
//
//  Created by Niko on 29/12/22.
//

import Foundation

extension String {
    static func makeHexStringFromInt(_ int: Int, withLeadingZeros: Int = 2) -> String {
        return String(format: "%0\(withLeadingZeros)x", int)
    }
}
