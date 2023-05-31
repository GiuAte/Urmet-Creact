//
//  EnergyViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 29/05/23.
//

import UIKit
import PlugUI

class EnergyViewController: UIViewController {
    
    // MARK: - Properties
    
    let currencies = ["Euro", "Dollaro USA", "Sterline", "Yen", "Franchi"]
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var showPickerButton: UIButton!
    var isPickerButtonOpen = false
    
    // MARK: - Lifecycle
     
     override func viewDidLoad() {
         super.viewDidLoad()
         setupUI()
         setupKeyboardDismissal()
         setupPickerView()
         setupTextField()
     }
     
     // MARK: - UI Setup
     
     private func setupUI() {
         isPickerButtonOpen = false
     }
     
     private func setupKeyboardDismissal() {
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
         view.addGestureRecognizer(tapGesture)
     }
     
     private func setupPickerView() {
         pickerView.delegate = self
         pickerView.dataSource = self
         pickerView.isHidden = !isPickerButtonOpen
     }
     
     private func setupTextField() {
         textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
     }
    
    // MARK: - Actions
    
    @objc private func textFieldDidEndEditing() {
        textField.resignFirstResponder()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func showPickerView(_ sender: Any) {
        isPickerButtonOpen = !isPickerButtonOpen
        
        if isPickerButtonOpen {
            pickerView.isHidden = false
            showPickerButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        } else {
            pickerView.isHidden = true
            showPickerButton.transform = .identity
        }
        view.layoutIfNeeded()
    }
}

// MARK: - UIPickerViewDataSource

extension EnergyViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
}

// MARK: - UIPickerViewDelegate

extension EnergyViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = currencies[row]
        print("Hai selezionato la valuta: \(selectedCurrency)")
    }
}
