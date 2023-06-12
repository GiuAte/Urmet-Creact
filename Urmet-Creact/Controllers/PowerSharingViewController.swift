//
//  PowerSharingViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 08/06/23.
//

import UIKit

class PowerSharingViewController: UIViewController {
    
    @IBOutlet private var switchButton: UISwitch!
    @IBOutlet private var tableView: UITableView!
    
    private var viewModel: PowerSharingViewModel!
    private var tableViewDataSource: PowerSharingTableVieDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PowerSharingViewModel()
        setTableView()
    }
    
    private func setTableView() {
        tableViewDataSource = PowerSharingTableVieDataSource(tableView: tableView, clousure: { [weak self] indexPath in
            guard self != nil else { return }
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction private func switchButtonToggled(_ sender: UISwitch) {
    
        
    }
}
