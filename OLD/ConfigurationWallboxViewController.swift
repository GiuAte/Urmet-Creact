//
//  ConfigurationWallboxViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 31/05/23.
//

import UIKit

class ConfigurationWallboxViewController: UIViewController {
    
    @IBOutlet private var firstTableView: UITableView!
    
    private var tableViewDataSource: SecondTVConfigurationWallbox?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableViewDataSource = SecondTVConfigurationWallbox(tableView: firstTableView, clousure: { [weak self] indexPath in
            guard let self = self else { return }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firstTableView.reloadData()
    }
    
}
