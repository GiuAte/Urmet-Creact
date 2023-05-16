//
//  LoginViewController.swift
//  CallMe
//
//  Created by Luca Lancellotti on 18/07/22.
//

import UIKit
import UserSdk

class LoginViewController: UIViewController {
    @IBOutlet private var labelTitle: UILabel!
    @IBOutlet private var labelDescription: UILabel!
    @IBOutlet private var textFieldEmail: InputTextField!
    @IBOutlet private var textFieldPassword: InputTextField!
    @IBOutlet private var buttonRecoveryPassword: UIButton!
    @IBOutlet private var labelRememberMe: UILabel!
    @IBOutlet private var switchRememberMe: UISwitch!
    @IBOutlet private var labelNewAccount: UILabel!
    @IBOutlet private var buttonSignUp: UIButton!
    @IBOutlet private var buttonSignIn: PrimaryButton!
    
    private var loader = LoaderViewController()
    
    let login = Login()
    let bundle = Bundle(for: LoginViewController.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login.delegate = self
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        buttonSignIn.isEnabled = false

        definesPresentationContext = true
        if UIScreen.main.bounds.height < 667 {
            let reducedSize: CGFloat = 5
            labelTitle.font = labelTitle.font.withSize(labelTitle.font.pointSize - reducedSize)
            labelDescription.font = labelDescription.font.withSize(labelDescription.font.pointSize - reducedSize)
            textFieldEmail.font = textFieldEmail.font!.withSize(textFieldEmail.font!.pointSize - reducedSize)
            textFieldPassword.font = textFieldPassword.font!.withSize(textFieldPassword.font!.pointSize - reducedSize)
            buttonRecoveryPassword.titleLabel?.font = buttonRecoveryPassword.titleLabel?.font.withSize(buttonRecoveryPassword.titleLabel!.font.pointSize - reducedSize)
            labelRememberMe.font = labelRememberMe.font.withSize(labelRememberMe.font.pointSize - reducedSize)
            labelNewAccount.font = labelNewAccount.font.withSize(labelNewAccount.font.pointSize - reducedSize)
            buttonSignUp.titleLabel?.font = buttonSignUp.titleLabel?.font.withSize(buttonSignUp.titleLabel!.font.pointSize - reducedSize)
            buttonSignIn.titleLabel?.font = buttonSignIn.titleLabel?.font.withSize(buttonSignIn.titleLabel!.font.pointSize - reducedSize)
        }

        localize()
    }

    private func popupError(error: Error) {
        let alert = AlertViewController(title: NSLocalizedString(convertError(error: error).0, tableName: Options.localizable, comment: ""), message: NSLocalizedString(convertError(error: error).1, tableName: Options.localizable, comment: ""), style: .error)
        present(alert, animated: true)
    }

    private func localize() {
        labelTitle.text = NSLocalizedString("Login.Title", tableName: Options.localizable, comment: "")
        labelDescription.text = NSLocalizedString("Login.Description", tableName: Options.localizable, comment: "")
        textFieldEmail.placeholder = NSLocalizedString("Login.Email", tableName: Options.localizable, comment: "")
        textFieldPassword.placeholder = NSLocalizedString("Login.Password", tableName: Options.localizable, comment: "")
        buttonRecoveryPassword.setAttributedTitle(NSAttributedString(string: NSLocalizedString("Login.RecoveryPassword", tableName: Options.localizable, comment: ""), attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.foregroundColor: UIColor.textWhite]), for: .normal)
        labelRememberMe.text = NSLocalizedString("Login.RememberMe", tableName: Options.localizable, comment: "")
        labelNewAccount.text = NSLocalizedString("Login.NewAccount", tableName: Options.localizable, comment: "")
        buttonSignUp.setAttributedTitle(NSAttributedString(string: NSLocalizedString("Login.SignUp", tableName: Options.localizable, comment: ""), attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.foregroundColor: UIColor.textWhite]), for: .normal)
        buttonSignIn.setTitle(NSLocalizedString("Login.SignIn", tableName: Options.localizable, comment: ""), for: .normal)
    }
    
    @IBAction private func loginPressed(_: Any) {
        guard let email = textFieldEmail.text,
              let password = textFieldPassword.text
        else { return }
        loader = LoaderViewController()
        present(loader, animated: false) { [weak self] in
            self?.login.executeLogin(rembemberMe: self?.switchRememberMe.isOn == true,
                                     email: email,
                                     password: password)
        }
    }
}

extension LoginViewController {
    private func convertError(error: Error) -> (String, String) {
        guard let error = error as? AuthenticatorWithUniqueGenerate.Error else { return ("", "") }
        switch error {
        case .invalidCredentials:
            return ("Login.Error", "Login.ErrorMessage")
        case .connectivity:
            return ("Generic.Error.Title", "Generic.Error.Description")
        case .internalError:
            return ("Generic.Error.Title", "Generic.Error.Description")
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        if textFieldEmail.text?.isEmpty == false  && textFieldPassword.text?.isEmpty == false {
            buttonSignIn.isEnabled = true
        } else {
            buttonSignIn.isEnabled = false
        }
        
        return true
    }
}

// MARK: - LoginDelegate

extension LoginViewController: LoginDelegate {
    
    func isLoginSuccessfull(_ isLogged: Bool,
                            rembemberMe: Bool,
                            email: String?,
                            password: String?,
                            session: URLSessionHTTPClient) {
        PlugUIContext.loginDelegate?.isLoginSuccessfull(isLogged,
                                                rembemberMe: rembemberMe,
                                                email: email,
                                                password: password,
                                                session: session)
        DispatchQueue.main.async { [weak self] in
            self?.loader.dismiss(animated: true)
        }
    }
    
    func error(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.loader.dismiss(animated: true) {
                self?.popupError(error: error)
            }
        }
    }
}

