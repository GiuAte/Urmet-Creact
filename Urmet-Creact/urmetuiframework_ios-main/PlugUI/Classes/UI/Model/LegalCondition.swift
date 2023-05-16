//
//  LegalCondition.swift
//  CallMe
//
//  Created by Luca Lancellotti on 30/08/22.
//

import Foundation

var defaultTerms = Terms()

class Terms {
    private let TermsDisabled = "TermsDisabled"

    var disabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: TermsDisabled)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: TermsDisabled)
            UserDefaults.standard.synchronize()
        }
    }

    var conditions: [LegalCondition]

    init() {
        conditions = []
        conditions.append(LegalCondition(name: "Condizioni generali di utilizzo", url: "https://www.google.it/", state: disabled ? .Denied : .Accepted, mandatory: true))
        conditions.append(LegalCondition(name: "Privacy Policy", url: "https://www.google.co.uk/", state: .Denied))
    }
}

class LegalCondition {
    enum State {
        case Accepted
        case Denied
        case None
    }

    var name: String
    var url: String
    var state: State
    var mandatory: Bool

    init(name: String, url: String, state: State = .None, mandatory: Bool = false) {
        self.name = name
        self.url = url
        self.state = state
        self.mandatory = mandatory
    }
}
