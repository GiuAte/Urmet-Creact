//
//  String+Style.swift
//  CallMe
//
//  Created by Luca Lancellotti on 25/07/22.
//

import UIKit

extension String {
    var isMandatory: Bool {
    switch lowercased() {
        case "true": return true
        default: return false
        }
    }
}

public extension String {
    enum Style {
        case HeaderH1Regular
        case HeaderH2Regular
        case HeaderH1Bold
        case Body1Regular
        case Body1RegularU
        case Body2Regular
        case Body2RegularU
        case Body3Regular
        case Body1Bold
        case Body2Bold
        case BodyModalRegular
        case Link1RegularU
        case Link2RegularU
        case Link3RegularU
        case ItemCronoLight
        case ItemCronoLightSub
        case ItemCronoRegular
    }

    func toStyle(_ style: Style, color: UIColor, alignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment

        switch style {
        case .HeaderH1Regular:
            paragraphStyle.lineHeightMultiple = 0.86
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Regular", size: 36) ?? UIFont.systemFont(ofSize: 36), range: NSRange(location: 0, length: count))

        case .HeaderH2Regular:
            paragraphStyle.lineHeightMultiple = 0.83
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Regular", size: 30) ?? UIFont.systemFont(ofSize: 30), range: NSRange(location: 0, length: count))

        case .HeaderH1Bold:
            paragraphStyle.lineHeightMultiple = 0.85
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Bold", size: 36) ?? UIFont.systemFont(ofSize: 36), range: NSRange(location: 0, length: count))

        case .Body1Regular:
            paragraphStyle.lineHeightMultiple = 0.97
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24), range: NSRange(location: 0, length: count))

        case .Body1RegularU:
            paragraphStyle.lineHeightMultiple = 0.97
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24), range: NSRange(location: 0, length: count))
            attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: count))

        case .Body2Regular:
            paragraphStyle.lineHeightMultiple = 1.06
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Regular", size: 19) ?? UIFont.systemFont(ofSize: 19), range: NSRange(location: 0, length: count))

        case .Body2RegularU:
            paragraphStyle.lineHeightMultiple = 1.06
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Regular", size: 19) ?? UIFont.systemFont(ofSize: 19), range: NSRange(location: 0, length: count))
            attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: count))

        case .Body3Regular:
            paragraphStyle.lineHeightMultiple = 1.04
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18), range: NSRange(location: 0, length: count))

        case .Body1Bold:
            paragraphStyle.lineHeightMultiple = 0.95
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24), range: NSRange(location: 0, length: count))

        case .Body2Bold:
            paragraphStyle.lineHeightMultiple = 0.94
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Bold", size: 21) ?? UIFont.systemFont(ofSize: 21), range: NSRange(location: 0, length: count))

        case .BodyModalRegular:
            paragraphStyle.lineHeightMultiple = 0.92
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Regular", size: 22) ?? UIFont.systemFont(ofSize: 22), range: NSRange(location: 0, length: count))

        case .Link1RegularU:
            paragraphStyle.lineHeightMultiple = 0.84
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24), range: NSRange(location: 0, length: count))
            attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: count))

        case .Link2RegularU:
            paragraphStyle.lineHeightMultiple = 1.06
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Regular", size: 21) ?? UIFont.systemFont(ofSize: 21), range: NSRange(location: 0, length: count))
            attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: count))

        case .Link3RegularU:
            paragraphStyle.lineHeightMultiple = 1.04
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18), range: NSRange(location: 0, length: count))
            attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: count))

        case .ItemCronoLight:
            paragraphStyle.lineHeightMultiple = 0.91
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Light", size: 14) ?? UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: count))

        case .ItemCronoLightSub:
            paragraphStyle.lineHeightMultiple = 0.91
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Light", size: 14) ?? UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: count))
            attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: count))

        case .ItemCronoRegular:
            paragraphStyle.lineHeightMultiple = 0.87
            attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Bariol-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: count))
        }

        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: count))
        return attributeString
    }
    
    var isValidPassword: Bool {
        let passRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$&+,:;|’<>.^*()%!-]).{7,}$"
        
        let passPred = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passPred.evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        let pattern = "^([a-zA-Z0-9_\\-.]+)@([a-zA-Z0-9_\\-]+)(\\.([a-zA-Z]{2,5}))+$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: count)
        
        return !regex.matches(in: self, options: [], range: range).isEmpty
    }
    
    var isIpAddress: Bool {
        var sin = sockaddr_in()
        return withCString { cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) } == 1
    }
}
