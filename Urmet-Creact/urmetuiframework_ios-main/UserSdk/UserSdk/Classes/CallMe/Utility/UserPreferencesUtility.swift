//
//  UserPreferencesUtility.swift
//  CallMeSdk
//
//  Created by Nicola Vettorello on 13/12/22.
//

import Foundation

struct UserPreferencesUtility {
    static func saveLastFileOpen(fileUrl: URL?, key: String) {
        let preferences = UserDefaults.standard
        preferences.set(fileUrl, forKey: key)
    }

    static func getLastFileOpen(key: String) -> URL? {
        let preferences = UserDefaults.standard
        return preferences.url(forKey: key)
    }
}
