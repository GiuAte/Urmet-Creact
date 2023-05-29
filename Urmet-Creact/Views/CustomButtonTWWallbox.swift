//
//  CustomButtonTWWallbox.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 23/05/23.
//

import UIKit

public class CustomButtonTWWallbox: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var imageCircle: UIView!
    @IBOutlet private var imageContent: UIImageView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
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
    
    private func setupButton() {
        
        imageCircle.backgroundColor = UIColor.white
        imageCircle.layer.cornerRadius = imageCircle.bounds.width / 2
        imageCircle.clipsToBounds = true
    }
    
}
