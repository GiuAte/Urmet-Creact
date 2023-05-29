//
//  CustomButtonHomePage.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 09/05/23.
//

import UIKit

public class CustomButtonHomePage: UITableViewCell {
    
    @IBOutlet private var firstLabel: UILabel!
    @IBOutlet private var secondLabel: UILabel!
    @IBOutlet private var firstButtonView: UIView!
    @IBOutlet private var buttonSettingsView: UIView!
    @IBOutlet private var buttonSettings: UIButton!
    
    var firstLabelText: String? {
        didSet {
            firstLabel.text = firstLabelText
        }
    }
    
    var secondLabelText: String? {
        didSet {
            secondLabel.text = secondLabelText
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    func setupButton() {
        buttonSettings.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        buttonSettings.layer.cornerRadius = buttonSettings.frame.size.width / 2
        buttonSettings.clipsToBounds = true
        secondLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        firstButtonView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
    }

}
