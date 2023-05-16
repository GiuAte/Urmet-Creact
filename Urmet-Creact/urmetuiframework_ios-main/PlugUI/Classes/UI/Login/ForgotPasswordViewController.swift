//
//  ForgotPasswordViewController.swift
//  CallMe
//
//  Created by Luca Lancellotti on 29/08/22.
//

import UIKit
import UserSdk

class ForgotPasswordViewController: UIViewController, IResetPassword {
    func success(value _: Bool) {
        DispatchQueue.main.async {
            self.loader.dismiss(animated: true) {
                self.showPopup()
            }
        }
    }

    func error(error: Error) {
        DispatchQueue.main.async {
            self.loader.dismiss(animated: true) {
                self.showPopup(error: error)
            }
        }
    }

    @IBOutlet private var turnButton: BackButton!
    @IBOutlet private var labelTitle: UILabel!
    @IBOutlet private var labelDescription: UILabel!
    @IBOutlet private var textFieldEmail: InputTextField!
    @IBOutlet private var buttonReset: PrimaryButton!
    
    let bundle = Bundle(for: ForgotPasswordViewController.self)
    private var loader = LoaderViewController()

    let reset = ResetPassword()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reset.delegate = self
        localize()
    }

    private func localize() {
        labelTitle.attributedText = NSLocalizedString("ForgotPassword.Title", tableName: Options.localizable, comment: "").toStyle(.HeaderH1Regular, color: .textWhite)
        labelDescription.attributedText = NSLocalizedString("ForgotPassword.Description", tableName: Options.localizable, comment: "").toStyle(.Body1Regular, color: .textWhite70)
        textFieldEmail.placeholder = NSLocalizedString("ForgotPassword.Email", tableName: Options.localizable, comment: "")
        buttonReset.setAttributedTitle(NSLocalizedString("ForgotPassword.Reset", tableName: Options.localizable, comment: "").toStyle(.Body1Regular, color: .textBlack), for: .normal)
    }

    @IBAction private func backTapped(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func emailChanged(_ sender: UITextField) {
        if sender.text?.isEmpty ?? true || !(sender.text?.isValidEmail ?? false) {
            buttonReset.isEnabled = false
        } else {
            buttonReset.isEnabled = true
        }
    }

    private func showPopup(error: Error? = nil) {
        let hasError = error == nil ? false : true
        let alert = AlertViewController(title: NSLocalizedString(hasError ? convertError(error: error ?? NSError()).0 : "ForgotPassword.Success", tableName: Options.localizable, comment: ""),
                                        message: NSLocalizedString(hasError ? convertError(error: error ?? NSError()).1 : "ForgotPassword.SuccessDescription", tableName: Options.localizable, comment: ""),
                                        style: hasError ? .error : .success)
        alert.addAction(AlertAction(title: NSLocalizedString("OK", tableName: Options.localizable, comment: ""),
                                    style: .default,
                                    handler: { _ in
            if !hasError {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        present(alert, animated: true)
    }

    @IBAction private func resetTapped(_: Any) {
        guard let email = textFieldEmail.text else { return }
        loader = LoaderViewController()
        present(loader, animated: false) {
            self.reset.resetPassword(email: email)
        }
    }
}

extension ForgotPasswordViewController {
    private func convertError(error: Error) -> (String, String) {
        guard let error = error as? ResetPasswordService.Error else { return ("", "") }
        switch error {
        case .emailNotFound:
            return ("ForgotPassword.Error", "ForgotPassword.ErrorDescription")
        default:
            return ("Generic.Error.Title", "Generic.Error.Description")
        }
    }
}
