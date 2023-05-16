//
//  CustomButton.swift
//  CallMe
//
//  Created by Luca Lancellotti on 19/07/22.
//

import UIKit

@IBDesignable
public class PrimaryButton: UIButton {
    
    enum Colors {
        static var outline: UIColor { return .clear }
        static var normal: UIColor { return UIColor.white }
        static var highlighted: UIColor { return UIColor.white }
        static var disabled: UIColor { return UIColor.white }
    }

    public var isOutline: Bool = false {
        didSet {
            updateBackgroundColor()
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public func setUnderlineText() {
        let attributedString = NSMutableAttributedString(string: titleLabel?.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: 1,
                                      range: NSMakeRange(0, attributedString.length))
        titleLabel?.attributedText = attributedString
    }
    
    func updateBackgroundColor() {
        commonInit()

        if isEnabled {
            alpha = 1.0
        } else {
            alpha = 0.3
        }
        
        setTitleColor(isOutline ? .textWhite : .textBlack, for: .normal)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = isOutline ? Colors.outline : Colors.normal
        setTitleColor(isOutline ? .textWhite : .textBlack, for: .normal)
        setTitleColor(isOutline ? .textWhite : .textBlack, for: .highlighted)
        setTitleColor(isOutline ? .textWhite : .textBlack, for: .disabled)
        
        if isOutline {
            guard let bariolFont = UIFont(name: "Bariol-Italic", size: 24) else { return }
            titleLabel?.font = bariolFont
        } else {
            guard let bariolFont = UIFont(name: "Bariol-Regular", size: 24) else { return }
            titleLabel?.font = bariolFont
        }
    }

}
