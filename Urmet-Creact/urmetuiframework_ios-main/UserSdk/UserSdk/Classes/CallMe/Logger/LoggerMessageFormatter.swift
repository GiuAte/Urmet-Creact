//
//  LoggerMessageFormatter.swift
//  CallMeSdk
//
//  Created by Niko on 07/12/22.
//

import Foundation

struct LoggerMessageFormatter {
    private static let DATE_FORMATTER = "yyyy/MM/dd HH:mm:ss.SSS"

    static func formatMessage(timestamp: String? = nil, tag: String, message: String, file: String, function: String, line: Int) -> String {
        var fullMessageFormatted = "\(tag) \(formatLogLocation(file, function, line)) \(message)"

        if let timestamp {
            fullMessageFormatted = "\(timestamp) \(fullMessageFormatted)"
        }

        return fullMessageFormatted
    }

    static func formatTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMATTER
        return dateFormatter.string(from: Date())
    }

    private static func formatLogLocation(_ file: String, _ function: String, _ line: Int) -> String {
        return "\(file) \(function):\(line)"
    }
}
