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
    }
    
    // MARK: - Button Actions
    
    @IBAction func toggleTableView(_ sender: UIButton) {
        isTableViewOpen = !isTableViewOpen
        
        UIView.animate(withDuration: 0.3) {
            if self.isTableViewOpen {
                self.tableView.isHidden = false
                let tableHeight = self.tableView.contentSize.height
                let maxHeight = self.view.frame.height * 0.7
                let height = min(tableHeight, maxHeight)
                let yOffset = self.view.frame.height - height
                self.tableView.frame.origin.y = yOffset
                self.tableView.frame.size.height = height
                
                self.toggleButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            } else {
                self.toggleButton.frame.origin.y = self.subtitleLabel.frame.maxY + 20
                self.tableView.frame.origin.y = self.toggleButton.frame.maxY
                self.tableView.frame.size.height = 0
                self.tableView.isHidden = true
                
                self.toggleButton.transform = .identity
            }
            self.view.layoutIfNeeded()
        }
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomWifiCell", for: indexPath) as! CustomWifiCell
        return cell
    }
}
