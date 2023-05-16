//
//  GDPRStatement.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 16/06/22.
//

import Foundation

public enum GDPRLanguage {
    case EN, IT, FR, ES, DE, PT, NL, RU
}

public struct GDPRStatement: Hashable, Decodable {
    public let id: String
    public let mandatory: Bool
    public let valid: Bool

    private let englishTitle: String
    private let englishContent: String
    private let englishUrl: String

    private let italianTitle: String
    private let italianContent: String
    private let italianUrl: String

    private let frenchTitle: String
    private let frenchContent: String
    private let frenchUrl: String

    private let spanishTitle: String
    private let spanishContent: String
    private let spanishUrl: String

    private let germanTitle: String
    private let germanContent: String
    private let germanUrl: String

    private let portugueseTitle: String
    private let portugueseContent: String
    private let portugueseUrl: String

    private let dutchTitle: String
    private let dutchContent: String
    private let dutchUrl: String

    private let russianTitle: String
    private let russianContent: String
    private let russianUrl: String

    private enum CodingKeys: String, CodingKey {
        case id = "STM_ID"
        case mandatory = "Mandatory"
        case valid = "Valid"

        case englishTitle = "STM_TITLE_EN"
        case englishContent = "STM_CONTENT_EN"
        case englishUrl = "STM_URL_EN"

        case italianTitle = "STM_TITLE_IT"
        case italianContent = "STM_CONTENT_IT"
        case italianUrl = "STM_URL_IT"

        case frenchTitle = "STM_TITLE_FR"
        case frenchContent = "STM_CONTENT_FR"
        case frenchUrl = "STM_URL_FR"

        case spanishTitle = "STM_TITLE_ES"
        case spanishContent = "STM_CONTENT_ES"
        case spanishUrl = "STM_URL_ES"

        case germanTitle = "STM_TITLE_DE"
        case germanContent = "STM_CONTENT_DE"
        case germanUrl = "STM_URL_DE"

        case portugueseTitle = "STM_TITLE_PT"
        case portugueseContent = "STM_CONTENT_PT"
        case portugueseUrl = "STM_URL_PT"

        case dutchTitle = "STM_TITLE_NL"
        case dutchContent = "STM_CONTENT_NL"
        case dutchUrl = "STM_URL_NL"

        case russianTitle = "STM_TITLE_RU"
        case russianContent = "STM_CONTENT_RU"
        case russianUrl = "STM_URL_RU"
    }

    public func getTitle(_ language: GDPRLanguage) -> String {
        switch language {
        case .EN:
            return englishTitle
        case .IT:
            return italianTitle
        case .FR:
            return frenchTitle
        case .ES:
            return spanishTitle
        case .DE:
            return germanTitle
        case .PT:
            return portugueseTitle
        case .NL:
            return dutchTitle
        case .RU:
            return russianTitle
        }
    }

    public func getContent(_ language: GDPRLanguage) -> String {
        switch language {
        case .EN:
            return englishContent
        case .IT:
            return italianContent
        case .FR:
            return frenchContent
        case .ES:
            return spanishContent
        case .DE:
            return germanContent
        case .PT:
            return portugueseContent
        case .NL:
            return dutchContent
        case .RU:
            return russianContent
        }
    }

    public func getUrl(_ language: GDPRLanguage) -> String {
        switch language {
        case .EN:
            return englishUrl
        case .IT:
            return italianUrl
        case .FR:
            return frenchUrl
        case .ES:
            return spanishUrl
        case .DE:
            return germanUrl
        case .PT:
            return portugueseUrl
        case .NL:
            return dutchUrl
        case .RU:
            return russianUrl
        }
    }
}

public extension GDPRStatement {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)

        let mandatoryString = try values.decode(String.self, forKey: .mandatory)
        mandatory = mandatoryString == "1" ? true : false

        let validString = try values.decode(String.self, forKey: .valid)
        valid = validString == "1" ? true : false

        englishTitle = try values.decodeIfPresent(String.self, forKey: .englishTitle) ?? ""
        englishContent = try values.decodeIfPresent(String.self, forKey: .englishContent) ?? ""
        englishUrl = try values.decodeIfPresent(String.self, forKey: .englishUrl) ?? ""

        italianTitle = try values.decodeIfPresent(String.self, forKey: .italianTitle) ?? ""
        italianContent = try values.decodeIfPresent(String.self, forKey: .italianContent) ?? ""
        italianUrl = try values.decodeIfPresent(String.self, forKey: .italianUrl) ?? ""

        frenchTitle = try values.decodeIfPresent(String.self, forKey: .frenchTitle) ?? ""
        frenchContent = try values.decodeIfPresent(String.self, forKey: .frenchContent) ?? ""
        frenchUrl = try values.decodeIfPresent(String.self, forKey: .frenchUrl) ?? ""

        spanishTitle = try values.decodeIfPresent(String.self, forKey: .spanishTitle) ?? ""
        spanishContent = try values.decodeIfPresent(String.self, forKey: .spanishContent) ?? ""
        spanishUrl = try values.decodeIfPresent(String.self, forKey: .spanishUrl) ?? ""

        germanTitle = try values.decodeIfPresent(String.self, forKey: .germanTitle) ?? ""
        germanContent = try values.decodeIfPresent(String.self, forKey: .germanContent) ?? ""
        germanUrl = try values.decodeIfPresent(String.self, forKey: .germanUrl) ?? ""

        portugueseTitle = try values.decodeIfPresent(String.self, forKey: .portugueseTitle) ?? ""
        portugueseContent = try values.decodeIfPresent(String.self, forKey: .portugueseContent) ?? ""
        portugueseUrl = try values.decodeIfPresent(String.self, forKey: .portugueseUrl) ?? ""

        dutchTitle = try values.decodeIfPresent(String.self, forKey: .dutchTitle) ?? ""
        dutchContent = try values.decodeIfPresent(String.self, forKey: .dutchContent) ?? ""
        dutchUrl = try values.decodeIfPresent(String.self, forKey: .dutchUrl) ?? ""

        russianTitle = try values.decodeIfPresent(String.self, forKey: .russianTitle) ?? ""
        russianContent = try values.decodeIfPresent(String.self, forKey: .russianContent) ?? ""
        russianUrl = try values.decodeIfPresent(String.self, forKey: .russianUrl) ?? ""
    }
}
