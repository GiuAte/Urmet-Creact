//
//  FileManager+fileSize.swift
//  CallMeSdk
//
//  Created by Niko on 07/12/22.
//

import Foundation

extension FileManager {
    func fileSizeInBytes(url: URL) -> Int64? {
        guard let attributes = try? attributesOfItem(atPath: url.path) else {
            return nil
        }
        return attributes[.size] as? Int64
    }

    func createDirectoriesAndMoveItem(at: URL, to: URL) throws {
        let directoryTarget = to.deletingLastPathComponent()
        try createDirectory(at: directoryTarget, withIntermediateDirectories: true)
        try moveItem(at: at, to: to)
    }
}
