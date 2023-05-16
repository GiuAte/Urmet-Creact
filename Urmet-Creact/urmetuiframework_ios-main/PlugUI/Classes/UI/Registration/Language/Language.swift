//
//  Language.swift
//  CryptoSwift
//
//  Created by Silvio Fosso on 01/02/23.
//

import Foundation
public enum AppLanguage: String {
    case EN, IT, FR, ES, DE, PT, NL, RU
}

public enum LanguageUtility {
    static let fallbackLang: AppLanguage = .EN

    public static func getLanguage(_ localeInstance: Locale = Locale.current) -> AppLanguage {
        if let language = localeInstance.languageCode {
            return AppLanguage(rawValue: language.uppercased()) ?? fallbackLang
        } else {
            return fallbackLang
        }
    }
}
