//
//  Color+CallMe.swift
//  CallMe
//
//  Created by Luca Lancellotti on 19/07/22.
//

import UIKit

public extension UIColor {
    static let background: UIColor = color(withName: "Background")
    static let backgroundWhite12: UIColor = color(withName: "BackgroundWhite12")
    static let backgroundWhite20: UIColor = color(withName: "BackgroundWhite20")
    static let textWhite: UIColor = color(withName: "TextWhite")
    static let textWhite30: UIColor = color(withName: "TextWhite30")
    static let textWhite50: UIColor = color(withName: "TextWhite50")
    static let textWhite70: UIColor = color(withName: "TextWhite70")
    static let textBlack: UIColor = color(withName: "TextBlack")
    static let orange200: UIColor = color(withName: "Orange200")
    static let blue500: UIColor = color(withName: "Blue500")
    static let greyRed500: UIColor = color(withName: "GreyRed500")
    static let green800: UIColor = color(withName: "Green800")

    private static func color(withName name: String) -> UIColor {
        #if TARGET_INTERFACE_BUILDER
            return UIColor(named: name, in: Bundle(for: ViewController.self), compatibleWith: nil) ?? .green
        #else
            return UIColor(named: name, in: Bundle(for: UIHandler.self), compatibleWith: nil) ?? UIColor.magenta
        #endif
    }

    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
