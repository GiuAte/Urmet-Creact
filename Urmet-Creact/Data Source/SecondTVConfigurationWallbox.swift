//
//  SecondTVConfigurationWallbox.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 01/06/23.
//

import UIKit


class SecondTVConfigurationWallbox: NSObject {
    
    // MARK: - Properties
    
    private var tableView: UITableView?
    var showAlertClosure: ((String) -> Void)?
    var onRowSelected: ((IndexPath) -> Void)?
    
    var cellViewModels: [SecondTableViewCustomCellTableViewCell]? {
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

    private func setupTableView() {
        tableView?.dataSource = self
        tableView?.delegate = self
        
        let cellNib = UINib(nibName: "SecondTableViewCustomCellTableViewCell", bundle: nil)
        tableView?.register(cellNib, forCellReuseIdentifier: "customCell")
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView?.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension SecondTVConfigurationWallbox: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.setupCellTVConfigurationWallbox.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 110.0
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! SecondTableViewCustomCellTableViewCell
        cell.selectionStyle = .none
        
        cell.firstLabelText = Constants.setupCellTVConfigurationWallbox[indexPath.row].0
        cell.secondLabelText = Constants.setupCellTVConfigurationWallbox[indexPath.row].1
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SecondTVConfigurationWallbox: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onRowSelected?(indexPath)
    }
}
