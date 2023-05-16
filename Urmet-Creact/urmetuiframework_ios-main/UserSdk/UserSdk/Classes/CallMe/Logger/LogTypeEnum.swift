//
//  LogTypeEnum.swift
//  CallMeSdk
//
//  Created by Niko on 07/12/22.
//

import Foundation

public enum LogType: String {
    case warning = "[WARNING]"
    case error = "[ERROR]"
    case debug = "[DEBUG]"
    case info = "[INFO]"

    var icon: String {
        switch self {
        case .warning: return "⚠️"
        case .error: return "🛑"
        case .debug: return "🐞"
        case .info: return "ℹ️"
        }
    }

    public var tagValue: String {
        return "\(icon) \(rawValue)"
    }
}
