//
//  CustomCellDetails.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 08/05/23.
//

import UIKit

public class CustomCell: UICollectionViewCell {
    
    @IBOutlet private var usernameFirstLetters: UILabel!
    @IBOutlet var customView: UIView!
    @IBOutlet private var fullName: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK: - FUNCTIONS
    
    func setNames(_ firstName: String, _ lastName: String) {
        let nameLastName = firstName.split(separator: " ")
        let firstNameInitial = firstName.prefix(1)
        let lastNameInitial = lastName.prefix(1)
        
        usernameFirstLetters.text = "\(nameLastName [safe: 0]?.first ?? Character(""))\(nameLastName [safe: 1]?.first ?? Character(""))"
        
        usernameFirstLetters?.font = UIFont.systemFont(ofSize: 33)
        
        let fullNameString = "\(nameLastName [safe: 0] ?? "") \(nameLastName [safe: 1]?.first ?? Character(""))."
        fullName?.text = fullNameString
        
        // Impostazione Vista del Cerchio
        customView.layer.cornerRadius = (customView.frame.size.width) / 2
        customView.layer.backgroundColor = UIColor.systemGray.cgColor
        customView.alpha = 0.3
        customView.clipsToBounds = true
    }
}
