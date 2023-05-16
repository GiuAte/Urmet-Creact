//
//  InputTextView.swift
//  CallMe
//
//  Created by Luca Lancellotti on 20/09/22.
//

import Foundation
import UIKit

@IBDesignable
class InputTextView: UIControl {
    private var labelTitle: UILabel!
    private var labelTitleTop: NSLayoutConstraint!
    private var labelTitleLeading: NSLayoutConstraint!
    private var labelPlaceholder: UILabel!
    private var textView: UITextView!
    private var stackViewLeading: NSLayoutConstraint!
    private var borderBottom: UIView!

    @IBInspectable var title: String? {
        didSet {
            if labelTitle != nil {
                updateLabelTitleText()
            }
        }
    }

    @IBInspectable var placeholder: String? {
        didSet {
            if labelPlaceholder != nil {
                updateLabelPlaceholderText()
            }
        }
    }

    @IBInspectable var text: String {
        get {
            return self.textView.text
        }
        set {
            self.labelPlaceholder.isHidden = true
            self.textView.isHidden = false
            self.textView.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        createLabelTitle()
        createStackView()
        createBorderBottom()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        roundCorners(corners: [.topLeft, .topRight], radius: 6)
    }

    func createLabelTitle() {
        let label = UILabel()
        label.attributedText = title?.toStyle(.Body3Regular, color: .textWhite70)
        label.backgroundColor = .clear
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        labelTitleLeading = label.leadingAnchor.constraint(equalTo: leadingAnchor)
        labelTitleLeading.isActive = true
        labelTitleTop = label.topAnchor.constraint(equalTo: topAnchor)
        labelTitleTop.isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        labelTitle = label
    }

    func createStackView() {
        let label = UILabel()
        label.attributedText = placeholder?.toStyle(.Body1Regular, color: .textWhite50)
        label.backgroundColor = .clear
        labelPlaceholder = label

        let textView = UITextView()
        textView.font = UIFont(name: "Bariol-Regular", size: 24)
        textView.isHidden = true
        textView.backgroundColor = .clear
        textView.textColor = .textWhite
        textView.delegate = self
        textView.tintColor = .textWhite
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.isScrollEnabled = false

        let stackView = UIStackView()
        stackView.axis = .vertical

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textView)

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackViewLeading = stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        stackViewLeading.isActive = true
        stackView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 13).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true

        textView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        self.textView = textView
    }

    func createBorderBottom() {
        let borderBottom = UIView()
        borderBottom.backgroundColor = .textWhite50
        addSubview(borderBottom)
        borderBottom.translatesAutoresizingMaskIntoConstraints = false
        borderBottom.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderBottom.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        borderBottom.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        borderBottom.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.borderBottom = borderBottom
    }

    func updateLabelTitleText() {
        labelTitle.attributedText = title?.toStyle(.Body3Regular, color: .textWhite70)
    }

    func updateLabelPlaceholderText() {
        labelPlaceholder.attributedText = placeholder?.toStyle(.Body1Regular, color: .textWhite50)
    }

    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        textView.becomeFirstResponder()
    }

    func focus() {
        textView.isHidden = false
        labelPlaceholder.isHidden = true
        labelTitleLeading.constant = 6
        labelTitleTop.constant = 6
        stackViewLeading.constant = 6
        backgroundColor = .backgroundWhite12
        borderBottom.backgroundColor = .textWhite
    }

    func unfocus() {
        labelTitleLeading.constant = 0
        labelTitleTop.constant = 0
        stackViewLeading.constant = 0
        backgroundColor = .clear
        if textView.text.isEmpty {
            textView.isHidden = true
            labelPlaceholder.isHidden = false
        } else {
            textView.isHidden = false
            labelPlaceholder.isHidden = true
        }
        borderBottom.backgroundColor = .textWhite50
    }
}

extension InputTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.sizeToFit()
    }

    func textViewDidBeginEditing(_: UITextView) {
        focus()
    }

    func textViewDidEndEditing(_: UITextView) {
        unfocus()
    }
}
