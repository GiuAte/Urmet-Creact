//
//  Options.swift
//  PlugUI
//
//  Created by Silvio Fosso on 15/11/22.
//

import Foundation
public enum Options {
    public static let localizable = "LocalizablePod"
    static var boardingStep: OnBoardingStepWrapper = .init(dictionary: NSDictionary())
    static func getResource(resource: Resource) {
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Configuration", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
            doResource(dictionary: nsDictionary ?? NSDictionary(), resource: resource)
        }
    }

    private static func doResource(dictionary: NSDictionary, resource: Resource) {
        switch resource {
        case .OnBoarding:
            boardingStep = OnBoardingStepWrapper(dictionary: dictionary)
        }
    }
}

enum Resource {
    case OnBoarding
}
