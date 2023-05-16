//
//  LogcatLogger.swift
//  CallMeSdk
//
//  Created by Niko on 29/11/22.
//

import Foundation
import os

struct ConsoleLogger: ILogger {
    func debug(tag: String, message: String, file: String, function: String, line: Int) {
        let textPrinted = "\(LogType.debug.tagValue) \(message)"
        os_log("%@", log: OSLog.default, type: .debug, LoggerMessageFormatter.formatMessage(tag: tag, message: textPrinted, file: file, function: function, line: line))
    }

    func info(tag: String, message: String, file: String, function: String, line: Int) {
        let textPrinted = "\(LogType.info.tagValue) \(message)"
        os_log("%@", log: OSLog.default, type: .info, LoggerMessageFormatter.formatMessage(tag: tag, message: textPrinted, file: file, function: function, line: line))
    }

    func warning(tag: String, message: String, file: String, function: String, line: Int) {
        let textPrinted = "\(LogType.warning.tagValue) \(message)"
        os_log("%@", log: OSLog.default, type: .fault, LoggerMessageFormatter.formatMessage(tag: tag, message: textPrinted, file: file, function: function, line: line))
    }

    func error(tag: String, message: String, file: String, function: String, line: Int) {
        let textPrinted = "\(LogType.error.tagValue) \(message)"
        os_log("%@", log: OSLog.default, type: .error, LoggerMessageFormatter.formatMessage(tag: tag, message: textPrinted, file: file, function: function, line: line))
    }

    func clean() -> Result<Bool, LoggerError> {
        return .success(true)
    }

    func exportOnFile(fileName _: String = "") -> Result<URL, LoggerError> {
        return .failure(.notImplemented)
    }
}
