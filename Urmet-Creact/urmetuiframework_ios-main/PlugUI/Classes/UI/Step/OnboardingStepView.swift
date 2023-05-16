//
//  OnboardingStepView.swift
//  CallMe
//
//  Created by Luca Lancellotti on 14/09/22.
//

import UIKit

class OnboardingStepView: UIView {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelDescription: UILabel!

    var image: UIImage {
        didSet {
            update()
        }
    }

    var title: String {
        didSet {
            update()
        }
    }

    var descriptionText: String {
        didSet {
            update()
        }
    }

    init(image: UIImage, title: String, description: String) {
        self.image = image
        self.title = title
        descriptionText = description
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        image = UIImage()
        title = ""
        descriptionText = ""
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        image = UIImage()
        title = ""
        descriptionText = ""
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
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

        update()
    }

    func update() {
        if imageView != nil {
            imageView.image = image
        }
        if labelTitle != nil {
            labelTitle.attributedText = title.toStyle(.HeaderH2Regular, color: .textWhite, alignment: .center)
        }
        if labelDescription != nil {
            labelDescription.attributedText = descriptionText.toStyle(.Body1Regular, color: .textWhite70, alignment: .center)
        }
    }
}
