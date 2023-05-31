//
//  ViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 08/05/23.
//

import UIKit
import Combine

//Sistemare logica delle classi nei ViewModel. Tutta la logica va tutta nel ViewModel

class HomePageViewController: UIViewController, TableViewDelegate {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var addUserText: UILabel!
    @IBOutlet private var addNewUserButton: UIButton!
    @IBOutlet private var collectionView: UICollectionView!
    
    private var popUpView: PopUpViewController?
    private var collectionViewDataSource: CollectionViewDataSource?
    private var tableViewDataSource: TableViewDataSource?
    private var wallboxConfigurationViewController: WallboxConfigurationViewController?
    private var energyViewController: EnergyViewController?
    
    private var viewModel: HomepageViewModel?
    final var cancelBag = Set<AnyCancellable>()
    
    //MARK: - LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDataSource()
        setupTableView()
        self.viewModel = HomepageViewModel()
        observer()
        self.viewModel?.populateCollectionView()
        
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
    
    private func observer() {
        viewModel?.isLoading
            .compactMap({$0})
            .receive(on: DispatchQueue.main)
            .sink{[weak self] in self?.collectionViewDataSource?.didSetValues(values: $0)}
            .store(in: &cancelBag)
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
        collectionViewDataSource = CollectionViewDataSource(collectionView: collectionView, with: nil)
    }
    
    //Creare func privata per indexPath
    
    private func setupTableView() {
        tableViewDataSource = TableViewDataSource(tableView: tableView, clousure: { [weak self] indexPath in
            guard let self = self else { return }
            self.energyViewController = EnergyViewController()
            //self.wallboxConfigurationViewController?.delegate = self
            self.energyViewController?.modalPresentationStyle = .pageSheet
            self.present(self.energyViewController!, animated: true)
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
    }
}
