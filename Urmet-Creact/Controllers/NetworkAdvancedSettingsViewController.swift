//
//  NetworkAdvancedSettingsViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 22/05/23.
//

import UIKit
import PlugUI

//NotificationCenter setup per modificare la View

class NetworkAdvancedSettingsViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var insertIPadress: UITextField!
    @IBOutlet var insertSubnetMask: UITextField!
    @IBOutlet var insertGatewayAddress: UITextField!
    @IBOutlet var continueButton: PrimaryButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?

    @IBOutlet var insertDNS: UITextField!
    
    // MARK: - Properties
    
    public weak var delegate: ButtonDelegate?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissal()
        setupTextFieldDelegates()
        setupButtonAppearance()
        updateContinueButtonAlpha()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
       }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    // MARK: - Setup
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupTextFieldDelegates() {
        insertIPadress.delegate = self
        insertSubnetMask.delegate = self
        insertGatewayAddress.delegate = self
        insertDNS.delegate = self
    }
    
    private func setupButtonAppearance() {
        continueButton.alpha = 0.3
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        updateContinueButtonAlpha()
    }
    
    // MARK: - Actions
    
    @IBAction func dismissButton(_ sender: UIButton) {
        delegate?.isClosingView()
        
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateContinueButtonAlpha() {
        let textFieldHasText = checkIfAnyTextFieldHasText(insertIPadress, insertSubnetMask, insertGatewayAddress, insertDNS)
        continueButton.alpha = textFieldHasText ? 1 : 0.3
    }
    
    private func checkIfAnyTextFieldHasText(_ textFields: UITextField...) -> Bool {
        for textField in textFields {
            if textField.hasText {
                return true
            }
        }
        return false
    }
    
    // MARK: - UITextFieldDelegate
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case insertIPadress:
            insertSubnetMask.becomeFirstResponder()
        case insertSubnetMask:
            insertGatewayAddress.becomeFirstResponder()
        case insertGatewayAddress:
            insertDNS.becomeFirstResponder()
        case insertDNS:
            dismissKeyboard()
        default:
            break
        }
        updateContinueButtonAlpha()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateContinueButtonAlpha()
        return true
    }
}

