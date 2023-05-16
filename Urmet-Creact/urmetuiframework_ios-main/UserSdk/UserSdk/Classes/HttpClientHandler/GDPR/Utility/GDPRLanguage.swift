//
//  GDPRLanguage.swift
//  CallMeSdk
//
//  Created by Silvio Fosso on 25/01/23.
//

import Foundation
extension GDPRLanguage {
    init(language: String) {
        switch language {
        case "EN":
            self = .EN

        case "IT":
            self = .IT

        case "FR":
            self = .FR

        case "ES":
            self = .ES

        case "DE":
            self = .DE

        case "PT":
            self = .PT

        case "NL":
            self = .NL

        case "RU":
            self = .RU

        default:
            self = .EN
        }
    }
}
