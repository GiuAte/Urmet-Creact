//
//  PowerSharingTableViewDataSource.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 08/06/23.
//

import UIKit

class PowerSharingTableVieDataSource: NSObject {
    
    // MARK: - Properties
    
    private var tableView: UITableView?
    var showAlertClosure: ((String) -> Void)?
    var onRowSelected: ((IndexPath) -> Void)?
    
    var cellViewModels: [PowerSharingTableViewCell]? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    // MARK: - Initialization
    
    init(tableView: UITableView, clousure: @escaping ((IndexPath) -> Void)) {
        self.tableView = tableView
        super.init()
        self.onRowSelected = clousure
        setupTableView()
        
    }
    
    // MARK: - METHODS
    
    private func setupTableView() {
        tableView?.dataSource = self
        tableView?.delegate = self
        
        let cellNib = UINib(nibName: "PowerSharingTableViewCell", bundle: nil)
        tableView?.register(cellNib, forCellReuseIdentifier: "customCell")
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView?.reloadData()
        tableView?.isScrollEnabled = false
    }
    
    func showAlert(message: String) {
        showAlertClosure?(message)
    }
}

// MARK: - UITableViewDataSource

extension PowerSharingTableVieDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! PowerSharingTableViewCell
        cell.selectionStyle = .none
        
        cell.firstLabelText = Constants.powerSharingTextCell[indexPath.row].0
        cell.secondLabelText = Constants.powerSharingTextCell[indexPath.row].1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

// MARK: - UITableViewDelegate

extension PowerSharingTableVieDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onRowSelected?(indexPath)
    }
}

