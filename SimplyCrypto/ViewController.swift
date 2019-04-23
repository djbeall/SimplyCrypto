//
//  ViewController.swift
//  SimplyCrypto
//
//  Created by Daniel Beall on 4/23/19.
//  Copyright © 2019 Group18. All rights reserved.
//

import UIKit

class CryptoCell: UITableViewCell {
    @IBOutlet weak var coinName: UILabel!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // change later
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath)
        if let myCell = cell as? CryptoCell {
            myCell.layer.borderWidth = 0.5
            myCell.coinName.text = String(indexPath.row)
        }
        return cell;
    }


}

