//
//  Logger.swift
//  CallMeSdk
//
//  Created by Nicola Vettorello on 09/12/22.
//

import Foundation

class Logger: ILogger {
    private static let LOGS_DIRECTORY = "Logs"
    private var loggers: [ILogger] = []

    init(isEnableConsoleLogging: Bool, isEnableFileLogging: Bool, maxFile: Int, sizeFile: Int64, fileName: String, encryptor: IEncrypt? = nil) {
        if isEnableConsoleLogging {
            addLogger(logger: ConsoleLogger())
        }

        if isEnableFileLogging {
            addLogger(logger: FileLogger(fileName: fileName,
                                         maxFileBytesSize: sizeFile,
                                         maxNumOfFile: maxFile,
                                         encryptor: encryptor))
        }
    }

    func debug(tag: String, message: String, file: String, function: String, line: Int) {
        for logger in loggers {
            logger.debug(tag: tag, message: message, file: file, function: function, line: line)
        }
    }

    func info(tag: String, message: String, file: String, function: String, line: Int) {
        for logger in loggers {
            logger.info(tag: tag, message: message, file: file, function: function, line: line)
        }
    }

    func warning(tag: String, message: String, file: String, function: String, line: Int) {
        for logger in loggers {
            logger.warning(tag: tag, message: message, file: file, function: function, line: line)
        }
    }

    func error(tag: String, message: String, file: String, function: String, line: Int) {
        for logger in loggers {
            logger.error(tag: tag, message: message, file: file, function: function, line: line)
        }
    }

    func clean() -> Result<Bool, LoggerError> {
        for logger in loggers {
            switch logger.clean() {
            case .success:
                continue
            case let .failure(loggerError):
                return .failure(loggerError)
            }
        }
        return .success(true)
    }

    public func exportOnFile(fileName: String = "Log") -> Result<URL, LoggerError> {
        guard let temporaryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(Logger.LOGS_DIRECTORY)
            .appendingPathComponent(fileName)
        else {
            return .failure(.cannotOpenDirectory(LoggerStringError.ERROR_UNACCESSIBLE_DIRECTORY))
        }

        switch createZipDirectory(temporaryUrl) {
        case .success: break
        case let .failure(loggerError): return .failure(loggerError)
        }

        switch copyLoggersDirectories(temporaryUrl) {
        case let .failure(loggerError): return .failure(loggerError)
        case .success: break
        }

        return zipDirectory(temporaryUrl, fileName: fileName)
    }

    private func createZipDirectory(_ dirUrl: URL) -> Result<Void, LoggerError> {
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: dirUrl.path) {
                try fileManager.removeItem(at: dirUrl)
            }
            try fileManager.createDirectory(at: dirUrl, withIntermediateDirectories: true)
        } catch {
            print(error.localizedDescription)
            return .failure(.cannotCreateDirectoryOrFile(error.localizedDescription))
        }

        return .success(())
    }

    private func copyLoggersDirectories(_ dirUrl: URL) -> Result<Bool, LoggerError> {
        let fileManager = FileManager.default
        for logger in loggers {
            do {
                let loggerDirectoryUrl = try logger.exportOnFile().get()
                let loggerDirectoryName = loggerDirectoryUrl.lastPathComponent
                let destinationUrl = dirUrl.appendingPathComponent(loggerDirectoryName)
                try fileManager.copyItem(at: loggerDirectoryUrl, to: destinationUrl)
            } catch LoggerError.notImplemented {
                continue
            } catch {
                if error is LoggerError {
                    return .failure(error as! LoggerError)
                } else {
                    return .failure(.generic(error.localizedDescription))
                }
            }
        }

        return .success(true)
    }

    private func zipDirectory(_ dirUrl: URL, fileName: String) -> Result<URL, LoggerError> {
        let fileManager = FileManager.default
        var destinationZipUrl: URL?
        var error: NSError?
        var loggerError: LoggerError?

        let coordinator = NSFileCoordinator()
        coordinator.coordinate(readingItemAt: dirUrl, options: [.forUploading], error: &error) { temporaryArchiveUrl in
            do {
                destinationZipUrl = try fileManager.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: temporaryArchiveUrl,
                    create: true
                ).appendingPathComponent(Logger.LOGS_DIRECTORY, isDirectory: true).appendingPathComponent("\(fileName).zip")

                if fileManager.fileExists(atPath: destinationZipUrl!.path) {
                    try fileManager.removeItem(at: destinationZipUrl!)
                }

                try fileManager.createDirectoriesAndMoveItem(at: temporaryArchiveUrl, to: destinationZipUrl!)

            } catch {
                print(error.localizedDescription)
                loggerError = .cannotCreateDirectoryOrFile(error.localizedDescription)
            }
        }
        guard let loggerError else {
            do {
                try fileManager.removeItem(at: dirUrl)
                return .success(destinationZipUrl!)
            } catch {
                return .failure(.generic(error.localizedDescription))
            }
        }
        return .failure(loggerError)
    }

    func addLogger(logger: ILogger) {
        loggers.append(logger)
    }
}
