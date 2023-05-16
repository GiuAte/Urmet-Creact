//
//  RegistrationStep.swift
//  CallMe
//
//  Created by Luca Lancellotti on 19/07/22.
//

import UIKit

class RegistrationStep: UIView {
    var canContinue: Bool = false {
        didSet {
            continueChanged?(canContinue)
        }
    }

    var continueChanged: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    internal func commonInit() {
        var view = UIView()

        let bundle = Bundle(for: type(of: self))

        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)

        let objects: NSArray = nib.instantiate(withOwner: self, options: nil) as NSArray

        for object in objects {
            if (object as AnyObject).isMember(of: UIView.self) {
                view = object as? UIView ?? UIView()
                break
            }
        }

        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
}
