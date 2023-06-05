//
//  CustomButtonTWWallboxTableViewCell.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 23/05/23.
//

import UIKit
import PlugUI

class CustomButtonTWWallboxTableViewCell: UITableViewCell {

    @IBOutlet private var circleButtonView: UIView!
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
    }

    
}
