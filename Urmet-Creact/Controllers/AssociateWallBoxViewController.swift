//
//  AssociateWallBoxViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 17/05/23.
//

import UIKit
import PlugUI

class AssociateWallBoxViewController: UIViewController {
    
    @IBOutlet var checkButtonView: UIView!
    @IBOutlet var singleUserButton: UIButton!
    @IBOutlet var multiUsersButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    
    var flag = false
    var flag1 = false
    
    public weak var delegate: ButtonDelegate?
    
    
    var blurredBackgroundView: UIImageView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(delegate: ButtonDelegate?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.delegate = delegate
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - SETUP UI
    
    private func setupUI() {
        setupCheckButtonView()
    }
    
    private func setupCheckButtonView() {
        checkButtonView.layer.cornerRadius = checkButtonView.bounds.width / 2
    }
    
    
    @IBAction func setupFirstButtonRadar(_ sender: UIButton) {
        
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        multiUsersButton.setImage(UIImage(systemName: "circle"), for: .normal)
        print("test1")
    }
    
    @IBAction func setupSecondButtonRadar(_ sender: UIButton) {
        
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        singleUserButton.setImage(UIImage(systemName: "circle"), for: .normal)
        print("test2")
    }
    
    
    
    @IBAction func dismissButton(_ sender: UIButton) {
        delegate?.isClosingView()
    }
}
