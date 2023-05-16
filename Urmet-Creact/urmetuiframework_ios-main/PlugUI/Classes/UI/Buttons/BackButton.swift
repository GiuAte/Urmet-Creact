//
//  BackButton.swift
//  CallMe
//
//  Created by Luca Lancellotti on 25/07/22.
//

import UIKit

@IBDesignable
class BackButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setImage(UIImage(named: "BackButton", in: Bundle(for: classForCoder), compatibleWith: nil), for: .normal)
    }

    override func prepareForInterfaceBuilder() {
        let image = UIImage(named: "BackButton", in: Bundle(for: classForCoder), compatibleWith: nil)
        setImage(image, for: .normal)

        super.prepareForInterfaceBuilder()
    }
}
