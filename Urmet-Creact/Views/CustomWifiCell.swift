//
//  WiFiConnectionCell.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 18/05/23.
//

import UIKit

//Creare function per settare la scritta personalizzata

class CustomWifiCell: UITableViewCell {

    @IBOutlet var labelTest: UILabel!
    
    var cellClickedClosure: (() -> Void)?
      
      override func awakeFromNib() {
          super.awakeFromNib()
      }
    
    public func customCellLabel(title: String) {
    
        labelTest.text = title
    }
    
    
  }
