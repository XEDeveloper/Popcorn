//
//  RecordsController.swift
//  Watcher
//
//  Created by Rj on 10/11/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

class RecordsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Accounts"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tappedClose))
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    @objc func tappedClose() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension RecordsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "identifier")
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
}

extension RecordsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
