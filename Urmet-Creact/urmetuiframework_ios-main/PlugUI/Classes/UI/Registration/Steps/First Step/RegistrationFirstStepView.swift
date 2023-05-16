//
//  RegistrationFirstStepView.swift
//  CallMe
//
//  Created by Luca Lancellotti on 19/07/22.
//

import UIKit

class RegistrationFirstStepView: RegistrationStep {
    @IBOutlet private var labelTitle: UILabel!
    @IBOutlet private var labelDescription: UILabel!
    @IBOutlet private var textFieldName: InputTextField!
    @IBOutlet private var textFieldSurname: InputTextField!
    @IBOutlet private var collectionViewCountry: UICollectionView!
    @IBOutlet var textFieldCountry: InputTextField!
    
    let bundle = Bundle(for: RegistrationFirstStepView.self)
    var country: Country? {
        didSet {
            updateCountry()
        }
    }

    var nameDidChange: ((String) -> Void)?
    var surnameDidChange: ((String) -> Void)?
    var countryDidChange: ((String) -> Void)?

    override internal func commonInit() {
        super.commonInit()
        textFieldCountry.rightArrow = true
        localize()
    }

    private func updateCountry() {
        canContinue()

        guard let country = country else {
            textFieldCountry.leftView = nil
            return
        }

        textFieldCountry.text = country.name
        countryDidChange?(textFieldCountry.text ?? "")

        let view = UIView()
        view.backgroundColor = .clear
        view.frame = CGRect(origin: .zero, size: CGSize(width: 32, height: 24))

        let imageView = UIImageView(image: UIImage(named: country.flag, in: bundle, compatibleWith: nil))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        textFieldCountry.leftView = view
        textFieldCountry.leftViewMode = .always
    }

    private func localize() {
        labelTitle.attributedText = NSLocalizedString("Registration.Welcome", tableName: Options.localizable, comment: "").toStyle(.HeaderH1Regular, color: .textWhite)
        labelDescription.attributedText = NSLocalizedString("Registration.Description", tableName: Options.localizable, comment: "").toStyle(.Body1Regular, color: .textWhite70)
        textFieldName.placeholder = NSLocalizedString("Registration.Name", tableName: Options.localizable, comment: "")
        textFieldSurname.placeholder = NSLocalizedString("Registration.Surname", tableName: Options.localizable, comment: "")
        textFieldCountry.placeholder = NSLocalizedString("Registration.Country", tableName: Options.localizable, comment: "")
    }

    @IBAction private func editingChanged(_ sender: UITextField) {
        if sender == textFieldName {
            nameDidChange?(sender.text ?? "")
        } else if sender == textFieldSurname {
            surnameDidChange?(sender.text ?? "")
        } else if sender == textFieldCountry {
            countryDidChange?(sender.text ?? "")
        }
        canContinue()
    }

    private func canContinue() {
        if !(textFieldName.text ?? "").isEmpty && !(textFieldSurname.text ?? "").isEmpty && country != nil {
            canContinue = true
        } else {
            canContinue = false
        }
    }
}
