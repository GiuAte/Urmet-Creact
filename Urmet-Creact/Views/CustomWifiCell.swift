//
//  WiFiConnectionCell.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 18/05/23.
//

import UIKit

//Creare function per settare la scritta personalizzata + clousure per quando premi sulla cella (alert hai premuto sulla cella)

class CustomWifiCell: UITableViewCell {

    @IBOutlet var labelTest: UILabel!
    
    var cellClickedClosure: (() -> Void)?
      
      override func awakeFromNib() {
          super.awakeFromNib()
          
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
          self.addGestureRecognizer(tapGesture)
      }
      
      func configure(withText text: String) {
          labelTest.text = text
      }
      
      @objc private func cellTapped() {
          cellClickedClosure?()
      }
  }
