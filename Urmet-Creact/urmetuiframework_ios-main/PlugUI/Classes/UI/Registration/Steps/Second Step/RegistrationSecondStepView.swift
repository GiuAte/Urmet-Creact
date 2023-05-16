//
//  RegistrationSecondStepView.swift
//  CallMe
//
//  Created by Luca Lancellotti on 19/07/22.
//

import UIKit

class RegistrationSecondStepView: RegistrationStep {
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelDescription: UILabel!
    @IBOutlet var textFieldEmail: InputTextField!
    @IBOutlet var textFieldPassword: InputTextField!
    @IBOutlet var textFieldRepeatPassword: InputTextField!
    @IBOutlet var labelRememberMe: UILabel!
    @IBOutlet var switchRememberMe: UISwitch!

    var emailDidChange: ((String) -> Void)?
    var passwordDidChange: ((String) -> Void)?
    var repeatPasswordDidChange: ((String) -> Void)?
    var rememberMeDidChange: ((Bool) -> Void)?

    override func commonInit() {
        super.commonInit()
        textFieldPassword.textContentType = .oneTimeCode
        textFieldRepeatPassword.textContentType = .oneTimeCode
        localize()
    }

    let bundle = Bundle(for: RegistrationSecondStepView.self)
    
    private func localize() {
        labelTitle.attributedText = NSLocalizedString("Registration.Welcome", tableName: Options.localizable, comment: "").toStyle(.HeaderH1Regular, color: .textWhite)
        labelDescription.attributedText = NSLocalizedString("Registration.Description", tableName: Options.localizable, comment: "").toStyle(.Body1Regular, color: .textWhite70)
        textFieldEmail.placeholder = NSLocalizedString("Registration.Email", tableName: Options.localizable, comment: "")
        textFieldPassword.placeholder = NSLocalizedString("Registration.Password", tableName: Options.localizable, comment: "")
        textFieldRepeatPassword.placeholder = NSLocalizedString("Registration.RepeatPassword", tableName: Options.localizable, comment: "")
        labelRememberMe.attributedText = NSLocalizedString("Registration.RememberMe", tableName: Options.localizable, comment: "").toStyle(.Body1Regular, color: .textWhite)
    }

    @IBAction private func editingChanged(_ sender: UITextField) {
        if sender == textFieldEmail {
            emailDidChange?(sender.text ?? "")
        } else if sender == textFieldPassword {
            passwordDidChange?(sender.text ?? "")
        } else if sender == textFieldRepeatPassword {
            repeatPasswordDidChange?(sender.text ?? "")
        }
        canContinue = checkValidation()
    }

    @IBAction private func switchChanged(_ sender: UISwitch) {
        rememberMeDidChange?(sender.isOn)
    }

    private func checkValidation() -> Bool {
        var validation = true
        if let email = textFieldEmail.text, !email.isEmpty {
            if !email.isValidEmail {
                textFieldEmail.errorText = NSLocalizedString("Registration.EmailError", tableName: Options.localizable, comment: "")
                validation = false
            } else {
                textFieldEmail.errorText = nil
            }
        } else {
            textFieldEmail.errorText = nil
            validation = false
        }
        if let password = textFieldPassword.text, !password.isEmpty {
            if !password.isValidPassword {
                textFieldPassword.errorText = NSLocalizedString("Registration.PasswordError", tableName: Options.localizable, comment: "")
                validation = false
            } else {
                textFieldPassword.errorText = nil
            }
        } else {
            textFieldPassword.errorText = nil
            validation = false
        }
        if let password = textFieldRepeatPassword.text, !password.isEmpty {
            if password != textFieldPassword.text {
                textFieldRepeatPassword.errorText = NSLocalizedString("Registration.RepeatPasswordError", tableName: Options.localizable, comment: "")
                validation = false
            } else {
                textFieldRepeatPassword.errorText = nil
            }
        } else {
            textFieldRepeatPassword.errorText = nil
            validation = false
        }
        return validation
    }
}
