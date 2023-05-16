//
//  RegistrationCountryCollectionViewCell.swift
//  CallMe
//
//  Created by Luca Lancellotti on 21/07/22.
//

import UIKit

class RegistrationCountryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: RegistrationCountryCollectionViewCell.self)

    @IBOutlet var imageViewFlag: UIImageView!
    @IBOutlet var labelName: UILabel!

    func configure(name: String, flag: String) {
        labelName.attributedText = name.toStyle(.Body2Regular, color: .textBlack)
        imageViewFlag.image = UIImage(named: flag, in: Bundle(for: RegistrationCountryCollectionViewCell.self), compatibleWith: nil)
    }
}
