//
//  WebView.swift
//  PlugUI
//
//  Created by Silvio Fosso on 02/02/23.
//

import UIKit
import WebKit
class WebView: UIViewController {
    @IBOutlet var webView: WKWebView!

    public var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_: Bool) {
        guard let url = url else { return }
        let Url = URL(string: url)!
        webView.load(URLRequest(url: Url))
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
