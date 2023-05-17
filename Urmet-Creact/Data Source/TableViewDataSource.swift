//
//  ViewControllerTableView.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 15/05/23.
//

import UIKit
import Foundation

class TableViewDataSource: NSObject {
    
    // MARK: - Properties
    
    private var tableView: UITableView?
    var showAlertClosure: ((String) -> Void)?
    var onRowSelected: ((IndexPath) -> Void)?
    
    var cellViewModels: [CustomButtonHomePage]? {
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
        
        let cellNib = UINib(nibName: "CustomButtonHomePage", bundle: nil)
        tableView?.register(cellNib, forCellReuseIdentifier: "customButton")
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView?.reloadData()
    }
    
    func showAlert(message: String) {
        showAlertClosure?(message)
    }
}

// MARK: - UITableViewDataSource

extension TableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.righeTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customButton", for: indexPath) as! CustomButtonHomePage
        cell.selectionStyle = .none
        
        cell.firstLabelText = Constants.righeTableView[indexPath.row].0
        cell.secondLabelText = Constants.righeTableView[indexPath.row].1
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TableViewDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onRowSelected?(indexPath)
    }
}

