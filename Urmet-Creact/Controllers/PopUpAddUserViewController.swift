//
//  PopUpAddUserViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 11/05/23.
//

import UIKit

class PopUpAddUserViewController: UIViewController {
    
    
    @IBOutlet weak var textTitleLabel: UILabel!
    @IBOutlet weak var textSubtitleLabel: UILabel!
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var exitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.isHidden = true
        setupQrCodeView()
        roundCornersOfPopUpView()
        
    }
     
    func setupQrCodeView() {
        qrCodeView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        qrCodeView.layer.cornerRadius = qrCodeView.frame.size.width / 2
        qrCodeView.clipsToBounds = true
    }
    
    func roundCornersOfPopUpView() {
        let cornerRadius: CGFloat = 10.0
        let maskPath = UIBezierPath(roundedRect: popUpView.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        popUpView.layer.mask = maskLayer
    }
}
