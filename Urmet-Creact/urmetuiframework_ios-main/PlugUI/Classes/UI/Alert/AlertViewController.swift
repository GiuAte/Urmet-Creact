//
//  AlertViewController.swift
//  CallMe
//
//  Created by Luca Lancellotti on 20/07/22.
//

import UIKit

public class AlertViewController: UIViewController {
    public enum Style {
        case `default`
        case success
        case error
        case alert
    }

    var style = Style.default {
        didSet {
            load()
        }
    }

    public override var title: String? {
        didSet {
            load()
        }
    }

    var message: String? {
        didSet {
            load()
        }
    }

    var attributedMessage: NSAttributedString? {
        didSet {
            load()
        }
    }

    var closeHidden: Bool = false {
        didSet {
            load()
        }
    }

    public var didTapClose: (() -> Void)?
    
    private var actions: [AlertAction] = []
    
    @IBOutlet private var stackOwner: UIStackView!

    @IBOutlet private var buttonClose: UIButton!
    @IBOutlet private var labelTitle: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var labelMessage: UILabel!
    @IBOutlet private var stackViewActions: UIStackView!

    private var configuration: PopupConfiguration?
    public init(title: String? = nil,
                message: String? = nil,
                attributedMessage: NSAttributedString? = nil,
                style: Style = .default,
                configuration: PopupConfiguration? = .none) {
        self.message = message
        self.attributedMessage = attributedMessage
        self.style = style
        super.init(nibName: nil, bundle: Bundle(for: AlertViewController.self))
        self.title = title
        self.configuration = configuration
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        load()
        loadActions()
    }

    func addAction(_ action: AlertAction) {
        action.viewController = self
        if stackViewActions != nil {
            stackViewActions.addArrangedSubview(action)
        }
        actions.append(action)
    }
    
    private func load() {
        if labelTitle != nil {
            DispatchQueue.main.async {
                self.labelTitle.attributedText = (self.title ?? "").toStyle(.HeaderH2Regular, color: .textWhite)
                if self.message != nil || self.attributedMessage != nil {
                    self.labelMessage.isHidden = false
                    if self.message != nil {
                        self.labelMessage.attributedText = (self.message ?? "")
                            .toStyle(.BodyModalRegular, color: .textWhite70)
                    } else if self.attributedMessage != nil {
                        self.labelMessage.attributedText = self.attributedMessage!
                    }
                }
                
                switch self.style {
                case .success:
                    self.imageView.isHidden = false
                    self.imageView.image = UIImage(named: "IconSuccessBig",
                                                   in: Bundle(for: AlertViewController.self),
                                                   compatibleWith: nil)
                case .error:
                    self.imageView.isHidden = false
                    self.imageView.image = UIImage(named: "IconFailedBig",
                                                   in: Bundle(for: AlertViewController.self),
                                                   compatibleWith: nil)
                case .alert:
                    self.imageView.isHidden = false
                    self.imageView.image = UIImage(named: "IconAlertBig",
                                                   in: Bundle(for: AlertViewController.self),
                                                   compatibleWith: nil)
                case .default:
                    self.imageView.isHidden = true
                }
                
                self.buttonClose.isHidden = self.closeHidden
                self.labelMessage.isHidden = self.message == nil
                
                guard let configuration = self.configuration else {
                    if self.stackViewActions.arrangedSubviews.isEmpty {
                        self.stackViewActions.isHidden = true
                    }
                    return
                }
                self.stackViewActions.isHidden = false
                PopupConfigurator.components(by: configuration).forEach { self.stackViewActions.addArrangedSubview($0) }
            }
        }
    }

    private func loadActions() {
        for action in actions {
            if action.superview == nil {
                stackViewActions.addArrangedSubview(action)
            }
        }
    }

    @IBAction private func closeTapped(_: Any) {
        dismiss(animated: true) {
            self.didTapClose?()
        }
    }
}

extension AlertViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetTransition.Present()
    }

    public func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetTransition.Dismiss()
    }
}

class AlertAction: UIButton {
    enum Style {
        case `default`
        case cancel
    }

    var viewController: UIViewController?

    var style = Style.default {
        didSet {
            load()
        }
    }

    var handler: ((AlertAction) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    init(title: String, style: Style = .default, handler: ((AlertAction) -> Void)? = nil) {
        self.handler = handler
        self.style = style
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        commonInit()
    }

    func commonInit() {
        titleLabel?.font = UIFont(name: "Bariol-Regular", size: 24)

        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 0, bottom: 13, trailing: 0)
            configuration.imagePadding = 8
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(name: "Bariol-Regular", size: 24)
                return outgoing
            }
            self.configuration = configuration
        } else {
            contentEdgeInsets = UIEdgeInsets(top: 13, left: 0, bottom: 13, right: 0)
        }
        addTarget(self, action: #selector(didTap), for: .touchUpInside)

        load()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.height / 2
    }

    func load() {
        switch style {
        case .cancel:
            backgroundColor = .clear
            borderWidth = 1
            borderColor = .white
            tintColor = .textWhite
            setTitleColor(.textWhite, for: .normal)
        case .default:
            backgroundColor = .white
            borderWidth = 0
            tintColor = .textBlack
            setTitleColor(.textBlack, for: .normal)
        }
    }

    @objc func didTap() {
        if let vc = viewController {
            vc.dismiss(animated: true, completion: {
                self.handler?(self)
            })
        } else {
            handler?(self)
        }
    }
}
