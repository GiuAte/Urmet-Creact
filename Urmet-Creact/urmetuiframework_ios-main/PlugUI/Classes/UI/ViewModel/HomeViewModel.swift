//
//  HomeViewModel.swift
//  CallMe
//
//  Created by Luca Lancellotti on 27/07/22.
//

import Foundation
import UIKit

class HomeViewModel {
    var userName = NSLocalizedString("Home.Welcome", comment: "") + "\nMarco"
    var imageProfile = UIImage(named: "Profilepicture")
    var calls = 0
    var alarms = 1
    var callsAndWarnings: NSAttributedString {
        let attributedString = (NSLocalizedString("Home.WhileAway", comment: "") + "\n").toStyle(.Body2Regular, color: .orange200)
        if calls != 0 {
            attributedString.append(("\(calls) " + NSLocalizedString("Home.Calls", comment: "")).toStyle(.Body2Bold, color: .orange200))
        }
        if calls != 0 && alarms != 0 {
            attributedString.append((" " + NSLocalizedString("Home.And", comment: "") + " ").toStyle(.Body2Regular, color: .orange200))
        }
        if alarms != 0 {
            attributedString.append(("\(alarms) " + NSLocalizedString("Home.Alarms", comment: "")).toStyle(.Body2Bold, color: .orange200))
        }
        return attributedString
    }

    var backgroundImage: UIImage? {
        return (calls + alarms > 0) ? UIImage(named: "HomeBackgroundWarning") : UIImage(named: "HomeBackground")
    }

    var viewInfoHidden: Bool {
        return calls + alarms == 0
    }

    var locations = defaultLocations

    var selectedLocation: Location?
}
