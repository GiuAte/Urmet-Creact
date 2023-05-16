//
//  ILogger.swift
//
//
//  Created by Nicola Vettorello on 29/11/22.
//

import Foundation

public protocol ILogger {
    func debug(tag: String, message: String, file: String, function: String, line: Int)
    func info(tag: String, message: String, file: String, function: String, line: Int)
    func warning(tag: String, message: String, file: String, function: String, line: Int)
    func error(tag: String, message: String, file: String, function: String, line: Int)
    func clean() -> Result<Bool, LoggerError>
    func exportOnFile(fileName: String) -> Result<URL, LoggerError>
}

public extension ILogger {
    func debug(tag: String = "", message: String, file: String = #fileID, function: String = #function, line: Int = #line) {
        return debug(tag: tag, message: message, file: file, function: function, line: line)
    }

    func info(tag: String = "", message: String, file: String = #fileID, function: String = #function, line: Int = #line) {
        return info(tag: tag, message: message, file: file, function: function, line: line)
    }

    func warning(tag: String = "", message: String, file: String = #fileID, function: String = #function, line: Int = #line) {
        return warning(tag: tag, message: message, file: file, function: function, line: line)
    }

    func error(tag: String = "", message: String, file: String = #fileID, function: String = #function, line: Int = #line) {
        return error(tag: tag, message: message, file: file, function: function, line: line)
    }

    func exportOnFile(fileName: String = "") -> Result<URL, LoggerError> {
        return exportOnFile(fileName: fileName)
    }
}
