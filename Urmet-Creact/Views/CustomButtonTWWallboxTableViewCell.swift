//
//  CustomButtonTWWallboxTableViewCell.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 23/05/23.
//

import UIKit
import PlugUI

class CustomButtonTWWallboxTableViewCell: UITableViewCell {

    @IBOutlet var circleButtonView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var circleButtonImageView: UIImageView!
    
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
        // Initialization code
    }

    
}
