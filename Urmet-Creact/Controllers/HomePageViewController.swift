//
//  ViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 08/05/23.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var addUserText: UILabel!
    @IBOutlet private var addNewUserButton: UIButton!
    @IBOutlet private var collectionView: UICollectionView!
    
    private var popUpView: PopUpViewController?
    private var associateWallBoxViewController: AssociateWallBoxViewController?
    private var collectionViewDataSource: CollectionViewDataSource?
    private var tableViewDataSource: TableViewDataSource?
    
    //MARK: - LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDataSource()
        setupTableView()
        overrideUserInterfaceStyle = .dark
    }
    
    // MARK: - UI SETUP
    
    private func setupUI() {
        customizeAddUserButton()
        customizeAddUserText()
        actionForAddUserButton()
    }
    
    private func customizeAddUserButton() {
        addNewUserButton.backgroundColor = UIColor.white
        addNewUserButton.layer.cornerRadius = addNewUserButton.bounds.width / 2
        addNewUserButton.clipsToBounds = true
    }
    
    private func customizeAddUserText() {
        addUserText.numberOfLines = 2
        addUserText.font = UIFont.systemFont(ofSize: 16)
        addUserText.text = "Aggiungi\nutente"
        addUserText.sizeToFit()
        view.addSubview(addUserText)
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.view.backgroundColor = UIColor.black
        alertController.view.alpha = 0.6
        alertController.view.layer.cornerRadius = 15
        
        alertController.modalPresentationStyle = .overFullScreen
        present(alertController, animated: false, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - POPUP HANDLING
    
    private func actionForAddUserButton() {
        addNewUserButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc private func buttonPressed() {
        let nibName = "PopUpViewController"
        popUpView = PopUpViewController(nibName: nibName, bundle: nil)
        popUpView?.delegate = self
        guard let popUpView = popUpView else { return }
        self.present(popUpView, animated: true)
        
    }
    
    //MARK: - SETUP COLLECTIONVIEW & TABLE VIEW
    
    private func setDataSource() {
        collectionViewDataSource = CollectionViewDataSource(collectionView: collectionView, with: ["Giulio Aterno", "Silvio Fosso", "Luigi Marino", "Andrea Ferrentino", "Andreana Perla", "Fabiana Chiocca", "Yehia Itani"])
    }
    
    private func setupTableView() {
        
        tableViewDataSource = TableViewDataSource(tableView: tableView, clousure: { indexPath in
            self.associateWallBoxViewController = AssociateWallBoxViewController(delegate: self, nibName: "AssociateWallBoxViewController", bundle: nil)
            guard let associateWallBoxViewController = self.associateWallBoxViewController else { return }
            associateWallBoxViewController.sheetPresentationController?.detents = [.medium(), .medium()]
            self.present(associateWallBoxViewController, animated: true)
            
        })
        tableViewDataSource?.showAlertClosure = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

//MARK: - POPUP DELEGATE

extension HomePageViewController: ButtonDelegate {
    func isClosingView() {
        popUpView?.dismiss(animated: true, completion: nil)
        associateWallBoxViewController?.dismiss(animated: true, completion: nil)
    }
}
