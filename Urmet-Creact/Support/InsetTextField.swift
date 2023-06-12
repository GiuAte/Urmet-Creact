//
//  InsetTextField.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 08/06/23.
//

import Foundation
import UIKit

class InsetTextField: UITextField {

    @IBInspectable var inset: CGPoint = .zero

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset.x, dy: inset.y)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

}
