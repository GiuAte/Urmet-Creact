//
//  ConfigurationButton.swift
//  CallMe
//
//  Created by Luca Lancellotti on 31/08/22.
//

import UIKit

@IBDesignable
class ConfigurationButton: UIButton {
    @IBInspectable var subtitle: String? = nil {
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

    private var labelSubtitle: UILabel!
    private var stackViewSubtitle: UIStackView!
    private var labelSubtitleTop: NSLayoutConstraint!
    private var labelSubtitleTopTitle: NSLayoutConstraint!
    private var labelSubtitleLeading: NSLayoutConstraint!
    private var labelSubtitleLeadingImage: NSLayoutConstraint!
    private var labelSubtitleLeadingTitle: NSLayoutConstraint!
    private var labelSubtitleTrailing: NSLayoutConstraint!
    private var labelSubtitleBottom: NSLayoutConstraint!
    private var labelEdit: UILabel!

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
        setImage(UIImage(named: "EmptyOption"), for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)

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

        let st = UIStackView()
        st.backgroundColor = .clear
        st.isUserInteractionEnabled = false
        addSubview(st)
        st.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: st, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: st, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: st, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true

        let modifica = UILabel()
        modifica.isHidden = false
        modifica.attributedText = NSLocalizedString("DeviceConfiguration.Edit", comment: "").toStyle(.Body2RegularU, color: .textWhite, alignment: .right)
        modifica.numberOfLines = 1
        modifica.font = titleLabel?.font?.withSize(19)
        modifica.textColor = .textWhite
        modifica.backgroundColor = .clear
        modifica.isUserInteractionEnabled = false
        st.addArrangedSubview(modifica)

        labelEdit = modifica
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if !isEnabled {
            alpha = 0.5
            labelEdit.isHidden = true
        } else {
            alpha = 1
            labelEdit.isHidden = false
        }

        if isSelected {
            if !isEnabled {
                // self.setImage(UIHandler.getImageFromBundle(by: ConfigurationHandler.shared.get(dictionaryName: "ConfigurationButton", nameofValue: "OptionDisabled"), classA: self.classForCoder), for: self.state)
            } else {
                //  self.setImage(UIHandler.getImageFromBundle(by: ConfigurationHandler.shared.get(dictionaryName: "ConfigurationButton", nameofValue: "Option"), classA: self.classForCoder), for: self.state)
            }
        } else {
            //  self.setImage(UIHandler.getImageFromBundle(by: ConfigurationHandler.shared.get(dictionaryName: "ConfigurationButton", nameofValue: "Empty"), classA: self.classForCoder), for: self.state)
        }
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
        }

        imageView?.frame.origin.y = 4
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
