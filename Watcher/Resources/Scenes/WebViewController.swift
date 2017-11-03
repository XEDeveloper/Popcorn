//
//  WebViewController.swift
//  Watcher
//
//  Created by Rj on 30/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var link: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webView.loadRequest(URLRequest(url: URL(string: link!)!))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tappedClose))
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.barStyle = .blackTranslucent
    }

    @objc func tappedClose() {
        dismiss(animated: true, completion: nil)
    }
    
}
