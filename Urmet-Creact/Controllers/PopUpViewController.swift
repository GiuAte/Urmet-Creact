//
//  PopUpViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 11/05/23.
//

import UIKit
import QRCode

final class PopUpViewController: UIViewController {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subTitleLabel: UILabel!
    @IBOutlet private var qrCodeView: UIView!
    @IBOutlet private var qrCodeImage: UIImageView!
    
    weak var delegate: ButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let qrCode = QRCode("Test del QRCode") {
            qrCodeImage.image = qrCode.image
        }
    }
    
    @IBAction private func dismissButton() {
        delegate?.isClosingView()
        
    }
    
}

