//
//  OnBoardingStepWrapper.swift
//  PlugUI
//
//  Created by Silvio Fosso on 30/01/23.
//

import Foundation
class OnBoardingStepWrapper {
    var steps = [OnBoardingStepClass]()
    init(dictionary: NSDictionary) {
        getItems(dictionary: dictionary)
    }

    private func getItems(dictionary: NSDictionary) {
        let st = dictionary["OnBoarding"] as? [String: [String]]
        guard let stepsArray = st?["Steps"] else { return }
        for step in stepsArray {
            print("\(step).Title")
            steps.append(OnBoardingStepClass(image: step, title: NSLocalizedString("\(step).Title", tableName: Options.localizable, comment: ""), description: NSLocalizedString("\(step).Description", tableName: Options.localizable, comment: "")))
        }
    }
}
