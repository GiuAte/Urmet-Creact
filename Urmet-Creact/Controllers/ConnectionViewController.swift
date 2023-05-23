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
    @IBOutlet var modifyButton: UIButton!
    @IBOutlet var setupNewConnection: UIView!
    @IBOutlet var wiFiLabel: UILabel!
    
    var wifiConnectionSelectorViewController: WiFiConnectionSelectorViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModifyButton()
    }
    
    func setupModifyButton() {
        modifyButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        modifyButton.tintColor = UIColor.white
        modifyButton.layer.cornerRadius = modifyButton.bounds.width / 2
        modifyButton.clipsToBounds = true
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
    
    @objc func presentController() {
        let wifiConnectionViewController = WiFiConnectionSelectorViewController()
        self.present(wifiConnectionViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func modifyButton(_ sender: UIButton) {
        presentController()
        print("ciao")
    }
}
