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
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subTitleLabel: UILabel!
    @IBOutlet private var understandLabel: UILabel!
    
    public weak var delegate: TableViewDelegate?
    
    private var customTitle: String
    private var customSubTitle: String
    
    init(customTitle: String, customSubTitle: String) {
        self.customTitle = customTitle
        self.customSubTitle = customSubTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.customTitle = ""
        self.customSubTitle = ""
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopUpView()
        titleLabel.text = customTitle
        subTitleLabel.text = customSubTitle
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
    }
    
    private func customizeContinueButton() {
        continueButton.backgroundColor = UIColor.gray
        continueButton.layer.borderColor = UIColor.black.cgColor
        continueButton.layer.borderWidth = 0.5
        continueButton.tintColor = UIColor.black
    }
    
    
    @IBAction func checkButtonStatus(_ sender: Any) {
        UIView.animate(withDuration: 0, animations: {
            if self.checkButton.imageView?.alpha == 0 {
                self.checkButton.imageView?.alpha = 1
                self.understandLabel.font = UIFont.boldSystemFont(ofSize: self.understandLabel.font.pointSize)
            } else {
                self.checkButton.imageView?.alpha = 0
                self.understandLabel.font = UIFont.systemFont(ofSize: self.understandLabel.font.pointSize)
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
        })
    }
    
}
