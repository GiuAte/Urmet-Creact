//
//  ConfigurationWallboxViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 31/05/23.
//

import UIKit

// Realizzare 1 singola tableview con 3 sezioni
// Utilizzare header and footer


class ConfigurationWallboxViewController: UIViewController {
    
    @IBOutlet private var firstTableView: UITableView!
    @IBOutlet var wiFiView: UIView!
    @IBOutlet private var secondTableView: UITableView!
    
    private var firstTableViewDataSource: WallboxConfigTableViewDataSource?
    private var secondTableViewDataSource: SecondTVConfigurationWallbox?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupButton()
        
    }
    
    func setupButton() {
        wiFiView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        wiFiView.layer.cornerRadius = wiFiView.frame.size.width / 2
        wiFiView.clipsToBounds = true
        wiFiView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
    }
    
    private func setupTableView() {
        
        firstTableViewDataSource = WallboxConfigTableViewDataSource(tableView: firstTableView, clousure: { [weak self] indexPath in guard let self = self else { return }
        })
        
        
        secondTableViewDataSource = SecondTVConfigurationWallbox(tableView: secondTableView, clousure: { [weak self] indexPath in
            guard let self = self else { return }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firstTableView.reloadData()
    }
    
}
