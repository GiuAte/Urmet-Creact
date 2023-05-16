//
//  Square Root.swift
//  CS.BigInt
//
//  Created by Károly Lőrentey on 2016-01-03.
//  Copyright © 2016-2017 Károly Lőrentey.
//

// MARK: Square Root

public extension CS.BigUInt {
    /// Returns the integer square root of a big integer; i.e., the largest integer whose square isn't greater than `value`.
    ///
    /// - Returns: floor(sqrt(self))
    func squareRoot() -> CS.BigUInt {
        // This implementation uses Newton's method.
        guard !isZero else { return CS.BigUInt() }
        var x = CS.BigUInt(1) << ((bitWidth + 1) / 2)
        var y: CS.BigUInt = 0
        while true {
            y.load(self)
            y /= x
            y += x
            y >>= 1
            if x == y || x == y - 1 { break }
            x = y
        }
        return x
    }
}

public extension CS.BigInt {
    /// Returns the integer square root of a big integer; i.e., the largest integer whose square isn't greater than `value`.
    ///
    /// - Requires: self >= 0
    /// - Returns: floor(sqrt(self))
    func squareRoot() -> CS.BigInt {
        precondition(sign == .plus)
        return CS.BigInt(sign: .plus, magnitude: magnitude.squareRoot())
    }
}
