//
//  Language.swift
//  CallMeSdk
//
//  Created by Silvio Fosso on 25/01/23.
//

import Foundation
class Language {
    static let language = Locale.current.languageCode?.uppercased() ?? "IT"

    static func gdprLanguage() -> GDPRLanguage {
        return GDPRLanguage(language: language)
    }
}
