//
//  InputTextField.swift
//  CallMe
//
//  Created by Luca Lancellotti on 18/07/22.
//

import UIKit

@IBDesignable
public class InputTextField: UITextField {
    private var viewLabelContainer: UIView!
    private var labelPlaceholder: UILabel!
    private var labelPlaceholderLeading: NSLayoutConstraint!
    private var backgroundView: UIView!
    private var borderBottom: UIView!
    private let horizontalMargin: CGFloat = 0
    private var stackView: UIStackView!
    private var viewError: UIView!
    private var labelError: UILabel!
    private var viewPasswordRequirements: UIView!
    private var labelPasswordRequirements: UILabel!
    private var imageViewArrow: UIImageView!
    let bundle = Bundle(for: InputTextField.self)
    var rightArrow: Bool = false {
        didSet {
            updateRightArrow()
        }
    }

    @IBInspectable var passwordRequirements: Bool = false {
        didSet {
            updatePasswordRequirements()
        }
    }

    @IBInspectable var placeholderColor: UIColor = .textWhite50 {
        didSet {
            updatePlaceholderColor()
            updateBorderBottom()
        }
    }

    @IBInspectable var activeBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.12) {
        didSet {
            updateBackgroundColor()
        }
    }

    public override var backgroundColor: UIColor? {
        get {
            return _backgroundColor
        }
        set {
            _backgroundColor = newValue
        }
    }

    private var _backgroundColor: UIColor?
    private var _textColor: UIColor?
    private var _placeholderRect: CGRect?

    public override var placeholder: String? {
        didSet {
            updatePlaceholderText()
        }
    }

    public override var textContentType: UITextContentType! {
        didSet {
            updateShowPassword()
        }
    }

    public var errorText: String? {
        didSet {
            updateErrorLabel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        createLabelPlaceholder()
        createBottomLabels()
        createBorderBottom()
        createArrow()

        clearButtonMode = .whileEditing

        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)

        updateControl()
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)

        let rect = CGRect(
            x: superRect.origin.x + (((text ?? "").isEmpty) ? 0 : horizontalMargin),
            y: superRect.origin.y + viewLabelContainer.frame.height + 5,
            width: superRect.size.width - (((text ?? "").isEmpty) ? 0 : horizontalMargin) * 2,
            height: superRect.size.height - viewLabelContainer.frame.height - stackView.frame.height - 10
        )

        return rect
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)

        var rect = CGRect(
            x: superRect.origin.x + horizontalMargin,
            y: superRect.origin.y + viewLabelContainer.frame.height + 5,
            width: superRect.size.width - horizontalMargin * 2,
            height: superRect.size.height - viewLabelContainer.frame.height - stackView.frame.height - 10
        )
        if isEditing {
            rect.origin.x += 6
            labelPlaceholderLeading.constant = horizontalMargin + 6
        } else {
            labelPlaceholderLeading.constant = horizontalMargin
        }
        if imageViewArrow != nil && !imageViewArrow.isHidden {
            rect.size.width -= imageViewArrow.frame.width - 16
        }
        if clearButtonMode == .whileEditing {
            rect.size.width -= 30
        }
        return rect
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.placeholderRect(forBounds: bounds)

        var rect = CGRect(
            x: superRect.origin.x,
            y: superRect.origin.y,
            width: superRect.size.width,
            height: superRect.size.height
        )
        if imageViewArrow != nil && !imageViewArrow.isHidden {
            imageViewArrow.frame.origin.x = self.bounds.width - imageViewArrow.frame.width - 8
            imageViewArrow.frame.origin.y = rect.origin.y + rect.height / 2 - imageViewArrow.frame.height / 2
            rect.size.width -= imageViewArrow.frame.width - 16
        }
        if isEditing {
            rect.size.width = 0
        }
        _placeholderRect = rect
        return rect
    }

    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.leftViewRect(forBounds: bounds)

        var rect = CGRect(
            x: superRect.origin.x,
            y: superRect.origin.y,
            width: superRect.width,
            height: superRect.height
        )
        if let placeholderRect = _placeholderRect {
            rect.origin.y = placeholderRect.origin.y + placeholderRect.height / 2 - rect.height / 2
        }
        return rect
    }

    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.rightViewRect(forBounds: bounds)

        var rect = CGRect(
            x: superRect.origin.x,
            y: superRect.origin.y,
            width: superRect.width,
            height: superRect.height
        )
        if let placeholderRect = _placeholderRect {
            rect.origin.y = placeholderRect.origin.y + placeholderRect.height / 2 - rect.height / 2
        }
        return rect
    }

    public override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.clearButtonRect(forBounds: bounds)

        var rect = CGRect(
            x: superRect.origin.x,
            y: superRect.origin.y,
            width: 22,
            height: 22
        )
        if let placeholderRect = _placeholderRect {
            rect.origin.y = placeholderRect.origin.y + placeholderRect.height / 2 - rect.height / 2
        }
        if imageViewArrow != nil && !imageViewArrow.isHidden {
            rect.origin.x = imageViewArrow.frame.origin.x - rect.width - 12
        }
        return rect
    }

    public override var intrinsicContentSize: CGSize {
        #if TARGET_INTERFACE_BUILDER
            self.setNeedsLayout()
            self.layoutIfNeeded()
        #endif

        return super.intrinsicContentSize
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if #unavailable(iOS 13.0) {
            for view in subviews {
                if let button = view as? UIButton {
                    button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                    button.tintColor = .white
                }
            }
        }

        #if TARGET_INTERFACE_BUILDER
            attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
            )
            labelPlaceholder.textColor = placeholderColor
            if text?.count == 0 {
                labelPlaceholder.isHidden = true
            } else {
                labelPlaceholder.isHidden = false
            }
        #else
            updateControl()

            invalidateIntrinsicContentSize()
        #endif
    }

    func createLabelPlaceholder() {
        let viewLabelContainer = UIView()
        viewLabelContainer.backgroundColor = .clear
        addSubview(viewLabelContainer)
        viewLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: viewLabelContainer, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: viewLabelContainer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: viewLabelContainer, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        self.viewLabelContainer = viewLabelContainer

        let label = UILabel()
        label.isHidden = true
        label.attributedText = placeholder?.toStyle(.Body3Regular, color: placeholderColor)
        label.backgroundColor = .clear
        viewLabelContainer.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: viewLabelContainer, attribute: .top, multiplier: 1.0, constant: 6).isActive = true
        labelPlaceholderLeading = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: viewLabelContainer, attribute: .leading, multiplier: 1.0, constant: horizontalMargin)
        labelPlaceholderLeading.isActive = true
        NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: viewLabelContainer, attribute: .trailing, multiplier: 1.0, constant: horizontalMargin).isActive = true
        NSLayoutConstraint(item: viewLabelContainer, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1.0, constant: 2).isActive = true
        labelPlaceholder = label
    }

    func createBottomLabels() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.backgroundColor = .clear
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        self.stackView = stackView

        let view = UIView()
        view.backgroundColor = .clear
        stackView.addArrangedSubview(view)
        view.isHidden = true
        viewError = view

        let imageView = UIImageView(image: UIImage(named: "IconaError", in: bundle, compatibleWith: nil))
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true

        let label = UILabel()
        label.numberOfLines = 0
        label.font = font?.withSize(18)
        label.backgroundColor = .clear
        label.textColor = UIColor(red: 251 / 255, green: 49 / 255, blue: 41 / 255, alpha: 1)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 8).isActive = true
        NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1.0, constant: 8).isActive = true
        NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: label, attribute: .trailing, multiplier: 1.0, constant: 8).isActive = true
        NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1.0, constant: 3).isActive = true
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        labelError = label

        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1.0, constant: 4).isActive = true

        let viewPass = UIView()
        viewPass.backgroundColor = .clear
        stackView.addArrangedSubview(viewPass)
        viewPass.isHidden = !passwordRequirements
        viewPasswordRequirements = viewPass

        let labelPass = UILabel()
        labelPass.numberOfLines = 0
        labelPass.attributedText = NSLocalizedString("PassworRequirements", tableName: Options.localizable, comment: "").toStyle(.Body3Regular, color: .textWhite50)
        labelPass.backgroundColor = .clear
        viewPass.addSubview(labelPass)
        labelPass.translatesAutoresizingMaskIntoConstraints = false
        labelPass.leadingAnchor.constraint(equalTo: viewPass.leadingAnchor).isActive = true
        labelPass.topAnchor.constraint(equalTo: viewPass.topAnchor, constant: 8).isActive = true
        labelPass.trailingAnchor.constraint(equalTo: viewPass.trailingAnchor).isActive = true
        labelPass.bottomAnchor.constraint(equalTo: viewPass.bottomAnchor).isActive = true
        labelPasswordRequirements = label
    }

    func createBorderBottom() {
        let borderBottom = UIView()
        borderBottom.backgroundColor = placeholderColor
        addSubview(borderBottom)
        borderBottom.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: borderBottom, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1).isActive = true
        NSLayoutConstraint(item: borderBottom, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: borderBottom, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: borderBottom, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        self.borderBottom = borderBottom

        let background = UIView()
        background.backgroundColor = _backgroundColor
        background.isUserInteractionEnabled = false
        insertSubview(background, at: 0)
        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: background, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: background, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: background, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: background, attribute: .bottom, relatedBy: .equal, toItem: borderBottom, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        backgroundView = background
    }

    func createArrow() {
        let imageView = UIImageView(image: UIImage(named: "DropdownDown", in: bundle, compatibleWith: nil))
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 24, height: 24))
        imageView.contentMode = .scaleToFill
        addSubview(imageView)
        imageViewArrow = imageView
    }

    func updatePlaceholderColor() {
        DispatchQueue.main.async {
            if self.isEditing {
                self.labelPlaceholder.isHidden = false
                self.attributedPlaceholder = NSAttributedString(
                    string: self.placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: self.textColor ?? .darkText]
                )
                self.labelPlaceholder.attributedText = self.placeholder?.toStyle(.Body3Regular, color: self.textColor ?? .white)
            } else {
                self.attributedPlaceholder = NSAttributedString(
                    string: self.placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: self.placeholderColor]
                )
                self.labelPlaceholder.attributedText = self.placeholder?.toStyle(.Body3Regular, color: .textWhite70)
                if self.text?.count == 0 {
                    self.labelPlaceholder.isHidden = true
                } else {
                    self.labelPlaceholder.isHidden = false
                }
            }
        }
    }

    func updatePlaceholderText() {
        labelPlaceholder.attributedText = placeholder?.toStyle(.Body3Regular, color: .textWhite70)
    }

    func updateBorderBottom() {
        if isEditing {
            borderBottom.backgroundColor = textColor
        } else {
            borderBottom.backgroundColor = placeholderColor
        }
    }

    func updateBackgroundColor() {
        DispatchQueue.main.async {
            if self.isEditing {
                self.backgroundView.backgroundColor = self.activeBackgroundColor
            } else {
                self.backgroundView.backgroundColor = self._backgroundColor
            }
        }
    }

    func updateErrorLabel() {
        DispatchQueue.main.async {
            if let text = self.errorText {
                if self._textColor == nil || self.textColor != self.labelError.textColor {
                    self._textColor = self.textColor
                }
                self.textColor = self.labelError.textColor
                self.viewError.isHidden = false
                self.labelError.text = text
            } else {
                if let color = self._textColor {
                    self.textColor = color
                }
                self.viewError.isHidden = true
            }
        }
    }

    func updateRightArrow() {
        DispatchQueue.main.async {
            if self.rightArrow {
                self.imageViewArrow.isHidden = false
                if self.isEditing {
                    self.imageViewArrow.image = UIImage(named: "ChevronUp", in: Bundle(for: InputTextField.self), compatibleWith: nil)
                } else {
                    self.imageViewArrow.image = UIImage(named: "DropdownDown", in: Bundle(for: InputTextField.self), compatibleWith: nil)
                }
            } else {
                self.imageViewArrow.isHidden = true
            }
        }
    }

    func updatePasswordRequirements() {
        DispatchQueue.main.async {
            if self.passwordRequirements {
                if self.isEditing || (self.text ?? "").isEmpty {
                    self.viewPasswordRequirements.isHidden = false
                } else {
                    self.viewPasswordRequirements.isHidden = true
                }
            } else {
                self.viewPasswordRequirements.isHidden = true
            }
        }
    }

    var buttonPassword: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PasswordShow", in: Bundle(for: InputTextField.self), compatibleWith: nil), for: .normal)
        button.setImage(UIImage(named: "PasswordHide", in: Bundle(for: InputTextField.self), compatibleWith: nil), for: .selected)
        return button
    }()

    @objc func togglePassword() {
        isSecureTextEntry = buttonPassword.isSelected
        buttonPassword.isSelected = !buttonPassword.isSelected
    }

    func updateShowPassword() {
        if textContentType == .password || textContentType == .newPassword {
            buttonPassword.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)
            if buttonPassword.superview == nil {
                rightView = buttonPassword
                rightViewMode = .always
            }
        } else {
            buttonPassword.removeFromSuperview()
            rightView = nil
            rightViewMode = .never
        }
    }

    func updateControl() {
        updatePlaceholderColor()
        updateBorderBottom()
        updateBackgroundColor()
        updateErrorLabel()
        updateRightArrow()
        updatePasswordRequirements()
        updateShowPassword()
    }

    @objc func editingDidBegin() {
        updateControl()
    }

    @objc func editingDidEnd() {
        updateControl()
    }
}
