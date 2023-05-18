//
//  WiFiConnectionSelectorViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 18/05/23.
//

import UIKit

class WiFiConnectionSelectorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    public weak var delegate: ButtonDelegate?
    var isTableViewOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    
    private func setupTableView() {
        tableView?.dataSource = self
        tableView?.delegate = self
        let nib = UINib(nibName: "CustomWifiCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "CustomWifiCell")
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView?.reloadData()
    }
    
    @IBAction func toggleTableView(_ sender: UIButton) {
        isTableViewOpen = !isTableViewOpen
        
        UIView.animate(withDuration: 0.3) {
            self.tableView.isHidden = !self.isTableViewOpen
            self.tableView.layoutIfNeeded()
        }
    }
     
    
    @IBAction func dismissButton(_ sender: UIButton) {
        delegate?.isClosingView()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomWifiCell", for: indexPath) as! CustomWifiCell
        
        return cell
    }
}
