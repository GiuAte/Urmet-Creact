//
//  SectionButton.swift
//  CallMe
//
//  Created by Luca Lancellotti on 22/07/22.
//

import UIKit

@IBDesignable
public class SectionButton: UIButton {
    @IBInspectable public var subtitle: String? = nil {
        didSet {
            updateSubtitle()
        }
    }

    @IBInspectable var attributedSubtitle: NSAttributedString? = nil {
        didSet {
            updateSubtitle()
        }
    }

    @IBInspectable var subtitleColor: UIColor = .textWhite70 {
        didSet {
            updateSubtitle()
        }
    }

    @IBInspectable var disabledBackgroundColor: UIColor?

    public var labelSubtitle: UILabel!
    private var stackViewSubtitle: UIStackView!
    private var labelSubtitleTop: NSLayoutConstraint!
    private var labelSubtitleTopTitle: NSLayoutConstraint!
    private var labelSubtitleLeading: NSLayoutConstraint!
    private var labelSubtitleLeadingImage: NSLayoutConstraint!
    private var labelSubtitleLeadingTitle: NSLayoutConstraint!
    private var labelSubtitleTrailing: NSLayoutConstraint!
    private var labelSubtitleBottom: NSLayoutConstraint!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    

    private func commonInit() {
        contentVerticalAlignment = .top
        contentHorizontalAlignment = .left
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = 0
        titleLabel?.adjustsFontSizeToFitWidth = false
        titleLabel?.adjustsFontForContentSizeCategory = false
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        if image(for: state) != nil {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        }

        createSubtitle()
    }

    func createSubtitle() {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.isUserInteractionEnabled = false
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        labelSubtitleTop = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 0)
        labelSubtitleLeading = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1.0, constant: 0)
        labelSubtitleTrailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: stackView, attribute: .trailing, multiplier: 1.0, constant: 0)
        labelSubtitleTrailing.isActive = true
        labelSubtitleBottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 0)
        labelSubtitleBottom.isActive = true

        let label = UILabel()
        label.isHidden = false
        label.text = subtitle
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = titleLabel?.font?.withSize(19)
        label.textColor = subtitleColor
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = false
        stackView.addArrangedSubview(label)

        labelSubtitle = label
        stackViewSubtitle = stackView
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        alpha = 1.0
        switch state {
        case .normal:
            backgroundColor = .backgroundWhite12
        case .highlighted:
            backgroundColor = .backgroundWhite20
        case .disabled:
            alpha = 0.5
            if let color = disabledBackgroundColor {
                backgroundColor = color
            } else {
                backgroundColor = .backgroundWhite12
            }
        case .selected:
            backgroundColor = .green800
        default:
            backgroundColor = .backgroundWhite12
        }
        layer.cornerRadius = 6
        imageView?.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        if ((subtitle != nil && !(subtitle?.isEmpty ?? true)) || (attributedSubtitle != nil)) && labelSubtitle != nil {
            contentVerticalAlignment = .top
            if titleLabel?.superview == self && !(titleLabel?.text ?? "").isEmpty {
                labelSubtitleTop.isActive = true
                labelSubtitleLeading.isActive = true
            } else {
                labelSubtitleTop.isActive = false
                labelSubtitleLeading.isActive = false
                labelSubtitle.isHidden = true
            }
            labelSubtitleTrailing.constant = contentEdgeInsets.right
            labelSubtitleBottom.constant = contentEdgeInsets.bottom
            labelSubtitle.font = titleLabel?.font?.withSize(19)
            if attributedSubtitle != nil {
                labelSubtitle.attributedText = attributedSubtitle
            } else {
                labelSubtitle.text = subtitle
            }
        } else {
            if currentImage != nil {
                contentVerticalAlignment = .center
            }
        }

        imageView?.frame.origin.y = frame.height / 2 - (imageView?.frame.height ?? 0) / 2
    }

    func updateSubtitle() {
        if labelSubtitle != nil {
            labelSubtitle.font = titleLabel?.font?.withSize(19)
            labelSubtitle.isHidden = subtitle == nil && attributedSubtitle == nil
            labelSubtitle.textColor = subtitleColor
            if attributedSubtitle != nil {
                labelSubtitle.attributedText = attributedSubtitle
            } else {
                labelSubtitle.text = subtitle
            }
        }
    }
}
