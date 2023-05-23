//
//  WiFiConnectionSelectorViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 18/05/23.
//

import UIKit

class WiFiConnectionSelectorViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toggleButton: UIButton!
    @IBOutlet var dismissButton: UIButton!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var selectWiFiLabel: UILabel!
    
    // MARK: - Properties
    
    public weak var delegate: ButtonDelegate?
    public weak var tableViewDelegate: TableViewDelegate?
    var isTableViewOpen = true
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSubviews()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "CustomWifiCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomWifiCell")
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        tableView.isHidden = true
        tableView.reloadData()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(toggleButton)
        view.addSubview(dismissButton)
        view.addSubview(subtitleLabel)
        view.bringSubviewToFront(toggleButton)
        view.bringSubviewToFront(selectWiFiLabel)
    }
    
    // MARK: - Button Actions
    
    @IBAction func toggleTableView(_ sender: UIButton) {
        isTableViewOpen = !isTableViewOpen
        
        if isTableViewOpen {
            tableView.isHidden = false
            toggleButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        } else {
            tableView.isHidden = true
            toggleButton.transform = .identity
        }
        view.layoutIfNeeded()
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        delegate?.isClosingView()
    }
}


// MARK: - UITableViewDelegate

extension WiFiConnectionSelectorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: "Cell Clicked", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension WiFiConnectionSelectorViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomWifiCell", for: indexPath) as? CustomWifiCell
        cell?.customCellLabel(title: "WiFi di casa")
        return cell ?? UITableViewCell()
    }
}
