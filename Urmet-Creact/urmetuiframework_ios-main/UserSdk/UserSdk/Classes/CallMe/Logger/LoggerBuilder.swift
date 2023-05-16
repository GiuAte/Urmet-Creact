//
//  LoggerBuilder.swift
//  CallMeSdk
//
//  Created by Nicola Vettorello on 11/12/22.
//

import Foundation

public class LoggerBuilder {
    private var isEnableConsoleLogging = true
    private var isEnableFileLogging = true
    private var maxFiles = 3
    private var sizeFile: Int64 = 1 * 1024 * 1024
    private var fileName = "CLIENT_LOG"
    private var encryptor: IEncrypt?

    public init() {}

    public func setEnableConsoleLogging(_ isEnable: Bool) -> LoggerBuilder {
        isEnableConsoleLogging = isEnable
        return self
    }

    public func setEnableFileLogging(_ isEnable: Bool) -> LoggerBuilder {
        isEnableFileLogging = isEnable
        return self
    }

    public func setMaxFiles(_ quantity: Int) -> LoggerBuilder {
        maxFiles = quantity
        return self
    }

    public func setDimensionFiles(bytesSize: Int64) -> LoggerBuilder {
        sizeFile = bytesSize
        return self
    }

    public func setFileName(_ name: String) -> LoggerBuilder {
        fileName = name
        return self
    }

    public func setEncryption(_ encryptor: IEncrypt?) -> LoggerBuilder {
        self.encryptor = encryptor
        return self
    }

    public func build() -> ILogger {
        return Logger(isEnableConsoleLogging: isEnableConsoleLogging,
                      isEnableFileLogging: isEnableFileLogging,
                      maxFile: maxFiles,
                      sizeFile: sizeFile,
                      fileName: fileName,
                      encryptor: encryptor)
    }
}
