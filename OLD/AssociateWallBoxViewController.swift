//
//  AssociateWallBoxViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 17/05/23.
//

import UIKit
import PlugUI

class AssociateWallBoxViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var checkButtonView: UIView!
    @IBOutlet private var singleUserButton: UIButton!
    @IBOutlet private var multiUsersButton: UIButton!
    @IBOutlet private var saveButton: UIButton!
    
    public weak var delegate: ButtonDelegate?
    var blurredBackgroundView: UIImageView?
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(delegate: ButtonDelegate?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.delegate = delegate
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        setupCheckButtonView()
    }
    
    private func setupCheckButtonView() {
        checkButtonView.layer.cornerRadius = checkButtonView.bounds.width / 2
    }
    
    // MARK: - Button Actions
    
    
    @IBAction func setupFirstButtonRadar(_ sender: UIButton) {
        
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        multiUsersButton.setImage(UIImage(systemName: "circle"), for: .normal)
        
    }
    
    @IBAction func setupSecondButtonRadar(_ sender: UIButton) {
        
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        singleUserButton.setImage(UIImage(systemName: "circle"), for: .normal)
        
    }
    
    
    
    @IBAction func dismissButton(_ sender: UIButton) {
        delegate?.isClosingView()
    }
}
