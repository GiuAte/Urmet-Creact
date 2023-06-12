//
//  CustomButtonTWWallboxTableViewCell.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 23/05/23.
//

import UIKit

class CustomButtonTWWallboxTableViewCell: UITableViewCell {

    @IBOutlet private var circleButtonView: UIView!
    @IBOutlet private var buttonView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var circleButtonImageView: UIImageView!
    
    var firstLabelText: String? {
        didSet {
            titleLabel.text = firstLabelText
        }
    }
    
    var secondLabelText: String? {
        didSet {
            subtitleLabel.text = secondLabelText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    func setupButton() {
        circleButtonView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        circleButtonView.layer.cornerRadius = circleButtonView.frame.size.width / 2
        circleButtonView.clipsToBounds = true
        circleButtonView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        
        buttonView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        buttonView.layer.cornerRadius = 15 
        buttonView.clipsToBounds = true
        buttonView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
    }

    
}
