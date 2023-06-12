//
//  WallboxConfigTableViewDataSource.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 24/05/23.
//

import UIKit
import Foundation

class WallboxConfigTableViewDataSource: NSObject {
    
    // MARK: - Properties
    
    private var tableView: UITableView?
    var showAlertClosure: ((String) -> Void)?
    var onRowSelected: ((IndexPath) -> Void)?
    
    var cellViewModels: [CustomButtonTWWallboxTableViewCell]? {
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
        
        let cellNib = UINib(nibName: "CustomButtonTWWallboxTableViewCell", bundle: nil)
        tableView?.register(cellNib, forCellReuseIdentifier: "cell")
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView?.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension WallboxConfigTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.textCustomButtonWallbox.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomButtonTWWallboxTableViewCell
        cell.selectionStyle = .none
        
        cell.firstLabelText = Constants.textCustomButtonWallbox[indexPath.row].0
        cell.secondLabelText = Constants.textCustomButtonWallbox[indexPath.row].1
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension WallboxConfigTableViewDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onRowSelected?(indexPath)
    }
}
