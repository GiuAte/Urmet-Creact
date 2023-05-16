//
//  FileLogger.swift
//
//
//  Created by Nicola Vettorello on 29/11/22.
//

import Foundation

class FileLogger: ILogger, LogsQueueDelegate {
    private static let SUFFIX_PREFERENCE_FILEURL = "_LOGFILE"
    private let directoryUrl: URL?
    private let fileName: String
    private static let FILE_EXTENSION = "log"
    private var maxFileBytesSize: Int64
    private var maxNumOfFile: Int
    private var encryptor: IEncrypt?
    private var queue = LogsQueue<String>()
    private var isWriterThreadAlive = false

    init(fileName: String, maxFileBytesSize: Int64, maxNumOfFile: Int, encryptor: IEncrypt?) {
        self.fileName = fileName
        self.maxFileBytesSize = maxFileBytesSize
        self.maxNumOfFile = maxNumOfFile
        self.encryptor = encryptor

        let bundleID = Bundle.main.bundleIdentifier ?? "com.example.sdklog"
        directoryUrl = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?
            .appendingPathComponent("Logs", isDirectory: true)
            .appendingPathComponent(bundleID, isDirectory: true)
            .appendingPathComponent("\(fileName)")

        queue.delegate = self
    }

    // MARK: ILogger

    func debug(tag: String, message: String, file: String, function: String, line: Int) {
        writeSchedule(type: LogType.debug.rawValue, formattedMessage: LoggerMessageFormatter.formatMessage(timestamp: LoggerMessageFormatter.formatTimestamp(), tag: tag, message: message, file: file, function: function, line: line))
    }

    func info(tag: String, message: String, file: String, function: String, line: Int) {
        writeSchedule(type: LogType.info.rawValue, formattedMessage: LoggerMessageFormatter.formatMessage(timestamp: LoggerMessageFormatter.formatTimestamp(), tag: tag, message: message, file: file, function: function, line: line))
    }

    func warning(tag: String, message: String, file: String, function: String, line: Int) {
        writeSchedule(type: LogType.warning.rawValue, formattedMessage: LoggerMessageFormatter.formatMessage(timestamp: LoggerMessageFormatter.formatTimestamp(), tag: tag, message: message, file: file, function: function, line: line))
    }

    func error(tag: String, message: String, file: String, function: String, line: Int) {
        writeSchedule(type: LogType.error.rawValue, formattedMessage: LoggerMessageFormatter.formatMessage(timestamp: LoggerMessageFormatter.formatTimestamp(), tag: tag, message: message, file: file, function: function, line: line))
    }

    func clean() -> Result<Bool, LoggerError> {
        guard let dirUrl = directoryUrl else {
            return .failure(.cannotOpenDirectory(LoggerStringError.ERROR_UNACCESSIBLE_DIRECTORY))
        }

        let fileManager = FileManager.default
        do {
            let logFiles = try fileManager.contentsOfDirectory(at: dirUrl, includingPropertiesForKeys: nil)
            for logFile in logFiles {
                try fileManager.removeItem(at: logFile)
                UserPreferencesUtility.saveLastFileOpen(fileUrl: nil, key: fileName.appending(FileLogger.SUFFIX_PREFERENCE_FILEURL))
            }
        } catch {
            print(error.localizedDescription)
            return .failure(.cannotWriteFile(error.localizedDescription))
        }
        return .success(true)
    }

    func exportOnFile(fileName _: String = "") -> Result<URL, LoggerError> {
        guard let url = directoryUrl else {
            return .failure(.cannotOpenDirectory(LoggerStringError.ERROR_UNACCESSIBLE_DIRECTORY))
        }
        return .success(url)
    }

    // MARK: LogsQueueDelegate

    func newLog() {
        if !isWriterThreadAlive {
            isWriterThreadAlive = true
            DispatchQueue.global(qos: .userInitiated).async {
                self.writeFileAt()
            }
        }
    }

    // MARK: Private

    private func writeSchedule(type: String, formattedMessage: String) {
        let textComposed = "\(type) \(formattedMessage)"
        let textPrinted: String
        do {
            textPrinted = try checkEncrypt(textComposed)
        } catch {
            print(error.localizedDescription)
            return
        }
        queue.insert(textPrinted)
    }

    private func writeFileAt() {
        var url: URL

        let result = retrieveUrlFileToWrite()
        switch result {
        case let .success(resultUrl):
            url = resultUrl
        case let .failure(loggerError):
            return print(loggerError.localizedDescription)
        }

        guard let fileHandle = FileHandle(forWritingAtPath: url.path) else {
            return print(LoggerStringError.ERROR_UNACCESSIBLE_FILE)
        }
        do {
            repeat {
                if let textPrinted = queue.remove() {
                    if #available(iOS 13.4, *) {
                        try fileHandle.seekToEnd()
                    } else {
                        fileHandle.seekToEndOfFile()
                    }

                    fileHandle.write(textPrinted.data(using: .utf8)!)
                    fileHandle.write("\n".data(using: .utf8)!)
                }
            } while queue.isEmpty

            do {
                if #available(iOS 13.0, *) {
                    try fileHandle.close()
                } else {
                    fileHandle.closeFile()
                }
                isWriterThreadAlive = false
            }
        } catch {
            return print(error.localizedDescription)
        }
    }

    private func retrieveUrlFileToWrite() -> Result<URL, LoggerError> {
        guard let fileURL = UserPreferencesUtility.getLastFileOpen(key: fileName.appending(FileLogger.SUFFIX_PREFERENCE_FILEURL)) else {
            return filePath(0)
        }
        return getUrlFileToWriteAt(fileURL)
    }

    private func getUrlFileToWriteAt(_ fileURL: URL) -> Result<URL, LoggerError> {
        let fileManager = FileManager.default
        guard let fileSize = fileManager.fileSizeInBytes(url: fileURL) else {
            if !fileManager.fileExists(atPath: fileURL.path) {
                return filePath(0)
            }
            return .failure(.cannotWriteFile(LoggerStringError.ERROR_UNACCESSIBLE_FILE))
        }

        if fileSize < maxFileBytesSize {
            return .success(fileURL)
        } else {
            return checkRotation(fileURL)
        }
    }

    private func checkRotation(_ fileURL: URL) -> Result<URL, LoggerError> {
        if maxNumOfFile > 1 {
            return checkRotationFile(fileURL)
        } else {
            return filePath(0)
        }
    }

    private func checkRotationFile(_ fileURL: URL) -> Result<URL, LoggerError> {
        let fileManager = FileManager.default

        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: fileURL.deletingLastPathComponent(), includingPropertiesForKeys: nil)
            if directoryContents.count < maxNumOfFile {
                return filePath(directoryContents.count)
            } else {
                return rotateFile(fileURL)
            }
        } catch {
            return .failure(.cannotOpenDirectory(error.localizedDescription))
        }
    }

    private func rotateFile(_ fileURL: URL) -> Result<URL, LoggerError> {
        if let index = Int(fileURL.pathExtension) {
            return checkNumOfFile(index)
        } else {
            return filePath(0)
        }
    }

    private func checkNumOfFile(_ index: Int) -> Result<URL, LoggerError> {
        let calculateIndex = (index + 1) < maxNumOfFile ? (index + 1) : 0
        return filePath(calculateIndex)
    }

    private func filePath(_ index: Int) -> Result<URL, LoggerError> {
        guard let destinationUrl = directoryUrl else {
            return .failure(.cannotOpenDirectory(LoggerStringError.ERROR_UNACCESSIBLE_DIRECTORY))
        }
        let fileURL = destinationUrl.appendingPathComponent(fileName).appendingPathExtension(FileLogger.FILE_EXTENSION).appendingPathExtension("\(index)")

        do {
            try createOrCleanFile(fileURL)
            return .success(fileURL)
        } catch {
            if error is LoggerError {
                return .failure(error as! LoggerError)
            } else {
                return .failure(.generic(error.localizedDescription))
            }
        }
    }

    private func createOrCleanFile(_ url: URL) throws {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path) {
            do {
                let destinationURL = url.deletingLastPathComponent()
                try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true)
                fileManager.createFile(atPath: url.path, contents: Data(String().utf8), attributes: nil)
            } catch {
                print(error.localizedDescription)
                throw LoggerError.cannotOpenDirectory(error.localizedDescription)
            }
        } else {
            do {
                try Data().write(to: url)
            } catch {
                print(error.localizedDescription)
                throw LoggerError.cannotWriteFile(error.localizedDescription)
            }
        }
        UserPreferencesUtility.saveLastFileOpen(fileUrl: url, key: fileName.appending(FileLogger.SUFFIX_PREFERENCE_FILEURL))
    }

    private func checkEncrypt(_ message: String) throws -> String {
        guard encryptor != nil else {
            return message
        }
        return try encryptMessage(message)
    }

    private func encryptMessage(_ message: String) throws -> String {
        guard let dataMessage = message.data(using: .utf8) else {
            throw CryptError.ErrorDataConversion
        }
        guard let cryptor = encryptor else {
            throw CryptError.ErrorEncryption("Encryptor not instantiate")
        }
        let result = cryptor.encryptToString(dataMessage)
        switch result {
        case let .success(cryptedMessage):
            return cryptedMessage
        case let .failure(cryptError):
            throw cryptError
        }
    }
}
