//
//  TransferDataViewController2.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 17/05/23.
//

import UIKit

class TransferDataViewController: UIViewController {
    
    
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var buttonView: UIView!
    @IBOutlet private var dismissButton: UIButton!
    @IBOutlet private var checkButton: UIButton!
    
    public weak var delegate: TableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopUpView()
    }
    
    //MARK: - UI SETUP
    
    private func setupPopUpView(){
        customizecheckButtonView()
        customizeDismissButton()
        customizeContinueButton()
        checkButton.imageView?.alpha = 0
    }
    
    private func customizecheckButtonView() {
        buttonView.backgroundColor = UIColor.black
        buttonView.layer.borderColor = UIColor.gray.cgColor
        buttonView.layer.borderWidth = 1
        buttonView.layer.cornerRadius = 5
        buttonView.clipsToBounds = true
    }
    
    private func customizeDismissButton() {
        dismissButton.backgroundColor = UIColor.black
        dismissButton.layer.borderColor = UIColor.white.cgColor
        dismissButton.layer.borderWidth = 0.5
        dismissButton.tintColor = UIColor.white
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: dismissButton.bounds, byRoundingCorners: [.topLeft, .bottomLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: dismissButton.bounds.height / 2, height: dismissButton.bounds.height / 2)).cgPath
        dismissButton.layer.mask = maskLayer
    }
    
    private func customizeContinueButton() {
        
        continueButton.backgroundColor = UIColor.gray
        continueButton.layer.borderColor = UIColor.black.cgColor
        continueButton.layer.borderWidth = 0.5
        continueButton.tintColor = UIColor.black
        
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: continueButton.bounds, byRoundingCorners: [.topLeft, .bottomLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: continueButton.bounds.height / 2, height: continueButton.bounds.height / 2)).cgPath
        continueButton.layer.mask = maskLayer
    }
    
    
    @IBAction func checkButtonStatus(_ sender: Any) {
        
        UIView.animate(withDuration: 0, animations: {
            if self.checkButton.imageView?.alpha == 0 {
                self.checkButton.imageView?.alpha = 1
            } else {
                self.checkButton.imageView?.alpha = 0
            }
        })
        
        UIView.animate(withDuration: 0, animations: {
            if self.continueButton.backgroundColor == UIColor.gray {
                self.continueButton.backgroundColor = UIColor.white
                self.continueButton.setTitleColor(UIColor.black, for: .normal)
            } else {
                self.continueButton.backgroundColor = UIColor.gray
                self.continueButton.setTitleColor(UIColor.white, for: .normal)
            }
        })    }
}
