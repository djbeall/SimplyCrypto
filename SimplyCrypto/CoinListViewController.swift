//
//  CoinListViewController.swift
//  SimplyCrypto
//
//  Created by Daniel Beall on 4/28/19.
//  Copyright © 2019 Group18. All rights reserved.
//

import UIKit

class CoinCell: UITableViewCell {
    
    @IBOutlet weak var coinName: UILabel!
}

class CoinListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var coinList: [String]? = ["hi"]
    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath)
        if let myCell = cell as? CoinCell {
            if let lst = coinList{
                myCell.coinName.text = lst[indexPath.row]
            }
           
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var lst = UserDefaults.standard.array(forKey: "MyCoins") as? [String] ?? [] as [String]
        if let currCell = tableView.cellForRow(at: indexPath) as? CoinCell {
            let newStr = currCell.coinName!.text! as String
            if !lst.contains(newStr) {
                lst.append(newStr)
                UserDefaults.standard.set(lst, forKey: "MyCoins")
                navigationController?.popViewController(animated: true)
            }
        }
           
        
    }

}
