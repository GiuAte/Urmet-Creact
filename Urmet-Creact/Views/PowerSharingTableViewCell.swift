//
//  PowerSharingTableViewCell.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 08/06/23.
//

import UIKit

class PowerSharingTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var radioButton: UIButton!
    @IBOutlet var subtitleLabel: UILabel!
    
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
