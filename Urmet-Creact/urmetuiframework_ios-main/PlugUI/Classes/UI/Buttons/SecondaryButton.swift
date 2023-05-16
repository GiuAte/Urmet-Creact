//
//  SecondaryButton.swift
//  CallMe
//
//  Created by Luca Lancellotti on 25/07/22.
//

import UIKit

@IBDesignable
public class SecondaryButton: UIButton {
    enum Colors {
        static var normal: UIColor { return .black }
        static var highlighted: UIColor { return UIColor(red: 214 / 255, green: 223 / 255, blue: 222 / 255, alpha: 0.12) }
        static var disabled: UIColor { return UIColor(red: 235 / 255, green: 239 / 255, blue: 255 / 255, alpha: 0.2) }
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

    private func commonInit() {
        setBackgroundColor(color: Colors.normal, forState: .normal)
        setTitleColor(.textWhite, for: .normal)
        setBackgroundColor(color: Colors.highlighted, forState: .highlighted)
        setTitleColor(.textWhite, for: .highlighted)
        setBackgroundColor(color: Colors.disabled, forState: .disabled)
        setTitleColor(.textWhite, for: .disabled)
        guard let bariolFont = UIFont(name: "Bariol-Regular", size: 24) else { return }
        titleLabel?.font = bariolFont
    }

    func updateBackgroundColor() {
        if isEnabled {
            backgroundColor = Colors.normal
            alpha = 1.0
        } else {
            backgroundColor = Colors.disabled
            alpha = 0.4
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        updateBackgroundColor()

        layer.borderWidth = 1.0
        layer.borderColor = UIColor(red: 235 / 255, green: 239 / 255, blue: 255 / 255, alpha: 1).cgColor
        layer.cornerRadius = frame.height / 2
        
    }
}
