//
//  LoggerErrorEnum.swift
//  CallMeSdk
//
//  Created by Niko on 15/12/22.
//

import Foundation

public enum LoggerError: Error {
    case cannotCreateDirectoryOrFile(String)
    case cannotWriteFile(String)
    case cannotOpenDirectory(String)

    case notImplemented
    case generic(String)
}

enum LoggerStringError {
    public static let ERROR_CREATE_DIRECTORY = "An error occurred during directories creation"
    public static let ERROR_UNACCESSIBLE_DIRECTORY = "Directory is unaccessible"
    public static let ERROR_UNACCESSIBLE_FILE = "File is unaccessible"
    public static let DIRECTORY_NOT_FOUND = "Request directory is not found"
}
