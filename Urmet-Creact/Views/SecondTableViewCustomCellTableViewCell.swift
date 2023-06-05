//
//  SecondTableViewCustomCellTableViewCell.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 31/05/23.
//

import UIKit

class SecondTableViewCustomCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
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
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func modifyButton(_ sender: Any) {
        
    }
    
}
