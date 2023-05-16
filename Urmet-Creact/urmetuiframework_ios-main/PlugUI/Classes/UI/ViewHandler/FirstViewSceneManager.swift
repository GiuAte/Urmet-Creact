//
//  FirstViewSceneManager.swift
//  CryptoSwift
//
//  Created by Silvio Fosso on 01/02/23.
//

import Foundation
import SwiftUI

class FirstViewSceneManager {
    enum Constants {
        enum Onboarding {
            static let OnboardingDone = "Start"
            static let LoginNavigationIdentifier = "loginNavigationController"
        }
    }

    private static var onboardingDone: Bool {
        return UserDefaults().bool(forKey: FirstViewSceneManager.Constants.Onboarding.OnboardingDone)
    }

    static func getUIWindowName() -> String? {
        if !onboardingDone {
            UserDefaults().set(true, forKey: FirstViewSceneManager.Constants.Onboarding.OnboardingDone)
            return Constants.Onboarding.OnboardingDone
        } else if onboardingDone {
            return Constants.Onboarding.LoginNavigationIdentifier
        }
        return nil
    }
}
