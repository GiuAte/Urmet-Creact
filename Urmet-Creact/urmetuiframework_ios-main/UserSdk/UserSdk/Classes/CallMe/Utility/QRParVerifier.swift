//
//  QRParVerifier.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 27/09/22.
//

import Foundation

public enum QRParVerifier {
    private static let EXPIRATION_WINDOW: Double = 300 // seconds - 5 minutes

    public static func isExpired(par: Int) -> Bool {
        guard let creationDate = QRParVerifier.getCreationDate(par) else {
            return true
        }

        let expirationDate = Date().addingTimeInterval(-EXPIRATION_WINDOW)
        let invalidationDate = Date().addingTimeInterval(EXPIRATION_WINDOW)
        if creationDate < expirationDate || creationDate > invalidationDate {
            return true
        }

        return false
    }

    private static func getCreationDate(_ par: Int) -> Date? {
        guard
            let ix = Int("c0affcfd", radix: 16),
            let y = Int("6b88c4f1", radix: 16)
        else {
            return nil
        }

        let p_2_32 = 4_294_967_296 // pow(2, 32)

        let xor = par ^ y
        var seconds = xor.multipliedReportingOverflow(by: ix).partialValue % p_2_32
        if seconds < 0 {
            seconds += p_2_32
        }

        return Date(timeIntervalSince1970: Double(seconds))
    }
}
