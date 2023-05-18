//
//  ConnectionViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 18/05/23.
//

import UIKit

class ConnectionViewController: UIViewController {
    
    @IBOutlet var button4G: UIButton!
    @IBOutlet var ethernetButton: UIButton!
    @IBOutlet var wiFiButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func setup4GButton(_ sender: UIButton) {
        
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        ethernetButton.setImage(UIImage(systemName: "circle"), for: .normal)
        wiFiButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @IBAction func setupEthernetButton(_ sender: UIButton) {
        
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        button4G.setImage(UIImage(systemName: "circle"), for: .normal)
        wiFiButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    @IBAction func setupWiFiButton(_ sender: UIButton) {
        
        sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        ethernetButton.setImage(UIImage(systemName: "circle"), for: .normal)
        button4G.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    
    
}
