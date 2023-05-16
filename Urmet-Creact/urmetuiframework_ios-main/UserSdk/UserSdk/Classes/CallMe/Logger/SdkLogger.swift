//
//  SdkLogger.swift
//  CallMeSdk
//
//  Created by Niko on 21/12/22.
//

import Foundation

class SdkLogger: Logger {
    private static let DEFAULT_ENABLE_CONSOLE_LOGGING = true
    private static let DEFAULT_ENABLE_FILE_LOGGING = true
    private static let DEFAULT_MAX_FILE_NUMBER = 3
    private static let DEFAULT_FILE_NAME = "SDK_CALLME_LOG"
    private static let DEFAULT_MAX_FILE_SIZE: Int64 = 1 * 1024 * 1024
    private static let DEFAULT_ENCRYPTOR = UrmetCryptoLog.defaultUrmetEncryptor()

    override init(isEnableConsoleLogging: Bool = SdkLogger.DEFAULT_ENABLE_CONSOLE_LOGGING,
                  isEnableFileLogging: Bool = SdkLogger.DEFAULT_ENABLE_FILE_LOGGING,
                  maxFile: Int = SdkLogger.DEFAULT_MAX_FILE_NUMBER,
                  sizeFile: Int64 = SdkLogger.DEFAULT_MAX_FILE_SIZE,
                  fileName: String = SdkLogger.DEFAULT_FILE_NAME,
                  encryptor: IEncrypt? = SdkLogger.DEFAULT_ENCRYPTOR)
    {
        var enableFile = isEnableFileLogging
        if encryptor == nil {
            enableFile = false
        }
        super.init(isEnableConsoleLogging: isEnableConsoleLogging,
                   isEnableFileLogging: enableFile,
                   maxFile: maxFile,
                   sizeFile: sizeFile,
                   fileName: fileName,
                   encryptor: encryptor)
    }
}
