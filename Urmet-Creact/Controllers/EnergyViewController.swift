//
//  EnergyViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 29/05/23.
//

import UIKit
import PlugUI

class EnergyViewController: UIViewController {
    
    let currencies = ["Euro", "Dollaro USA", "Sterline", "Yen", "Franchi"]
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissal()
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textFieldDidEndEditing() {
        textField.resignFirstResponder()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
