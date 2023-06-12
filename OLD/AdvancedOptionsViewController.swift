//
//  AdvancedOptionsViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 07/06/23.
//

import UIKit

class AdvancedOptionsViewController: UIViewController {
    
    //MARK: - Iboutlets
    
    @IBOutlet private var advancedOptionLabel: UILabel!
    @IBOutlet private var setupServerLabel: UILabel!
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var switchAction: UISwitch!
    @IBOutlet var identityTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet private var ocppLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissal()
        registerKeyboardNotifications()
        setupTextFieldReturnKey()
    }
    
    deinit {
        unregisterKeyboardNotifications()
    }
    
    // MARK: - Keyboard Handling
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150
    }
    
    @objc private func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: - Tap Gesture and Keyboard Dismissal
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - TextField Handling

extension AdvancedOptionsViewController: UITextFieldDelegate {
    
    func setupTextFieldReturnKey() {
        urlTextField.delegate = self
        identityTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard switchAction.isOn else {
            return false
        }
        
        switch textField {
        case urlTextField:
            identityTextField.becomeFirstResponder()
        case identityTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            dismissKeyboard()
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.isEnabled = switchAction.isOn
    }
    
    @IBAction func switchActionPressed(_ sender: UISwitch) {
        urlTextField.isEnabled = sender.isOn
        identityTextField.isEnabled = sender.isOn
        passwordTextField.isEnabled = sender.isOn
        
        if sender.isOn {
            urlTextField.becomeFirstResponder()
        } else {
            urlTextField.text = ""
            identityTextField.text = ""
            passwordTextField.text = ""
            
            urlTextField.resignFirstResponder()
            identityTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
        }
    }
}
