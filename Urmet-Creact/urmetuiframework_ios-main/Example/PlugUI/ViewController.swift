//
//  ViewController.swift
//  PlugUI
//
//  Created by Silvio fosso on 11/14/2022.
//  Copyright (c) 2022 Silvio fosso. All rights reserved.
//

import PlugUI
import UIKit
class ViewController: UIViewController {
    @IBOutlet var v: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidAppear(_: Bool) {
        // let v = LoaderViewController()
        // let view = UIHandler.instantiateView(controller: self)
        // view.delegate = self
        // present(view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
