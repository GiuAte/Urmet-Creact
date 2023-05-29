//
//  WallboxConfigurationViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 23/05/23.
//

import UIKit

class WallboxConfigurationViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView: UITableView!
    
    private var wallboxTableViewDataSource: WallboxConfigTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
    }
    
    
    private func setupTableView() {
        wallboxTableViewDataSource = WallboxConfigTableViewDataSource(tableView: tableView, clousure: { [weak self] indexPath in
            guard self != nil else { return }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

